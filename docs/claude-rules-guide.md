# Agent 规则系统 · 上手指南

> 面向：刚接触这套 `~/.claude/` / `~/.codex/` 共享规则系统的开发者。
> 目标：理解如何用同一套规则指导 Claude Code、Codex 等 agentic coding tools，并把日常项目工作拆到多 agent 可协作的粒度。

---

## 一、这是什么

这是一套全局 agent 规则系统，用来约束不同编码 agent 在项目里的工作方式。它解决的核心问题是：

- 同类任务的执行方式不稳定。
- `CLAUDE.md` / `AGENTS.md` 容易各写一套，形成两种语境。
- 任务要么直接动手、缺少交接面，要么流程过重、难以执行。

这套系统的回答是：**用少量规则把工作切成可闭环、可验证、可 review、可交接的 agent 执行单元。**

---

## 二、文件结构

Claude 与 Codex 使用同构文件：

```text
~/.claude/
├── CLAUDE.md
└── rules/
    ├── planning.md
    ├── testing.md
    ├── code-review.md
    ├── documentation.md
    ├── delegation.md
    ├── architecture.md
    └── english.md

~/.codex/
├── AGENTS.md
└── rules/
    ├── planning.md
    ├── testing.md
    ├── code-review.md
    ├── documentation.md
    ├── delegation.md
    ├── architecture.md
    └── english.md
```

**关键设计：** `claude/CLAUDE.md` 和 `claude/rules/*.md` 是 dotfiles 中的维护单源；`codex/AGENTS.md` 和 `codex/rules/*.md` 在仓库内用 symlink 指向 Claude 单源，只保留 Codex 需要的文件名入口。`scripts/restore.sh` 安装到 `$HOME` 时直接把 `~/.codex/AGENTS.md` 和 `~/.codex/rules/*.md` 链到 `claude/` 单源，避免双层 symlink。文本使用 agent-neutral 语境；平台差异只用“current agent environment”这类中性表达承载。

---

## 三、三种工作模式

模式不是按个人/团队、项目大小或耗时比例来选，而是按 **agent 可执行粒度** 来选。

### 1. `quick-fix`

**适用：** 主 agent 能在单轮中闭环的任务。

**流程：** `think/hunt -> build -> check -> docs update`

**特征：**
- 不需要持久 spec / plan / task 文档。
- 开始前给一段轻量计划即可。
- 只适合主 agent 单轮闭环，不需要 delegated implementation，也没有并行写入域。
- 如果发现需要独立 delegated agent、持久任务状态或并行写入域，升级到 `spec-driven-full`。

### 2. `spec-driven-full`

**适用：** 需要拆成 agent-sized tasks 的任务。

**流程：** `spec -> plan -> task -> code -> unit -> integration -> e2e`

**关键纪律：**
- Spec 对齐目标和验收标准。
- Plan 标注串行链与可并行 task 组。
- 多 agent 写代码前先确定每个 task 的 branch / worktree 策略。
- Task 必须能冷启动派发给 delegated agent。
- 编码必须留在已批准 task 范围内。

### 3. `superteam`

**适用：** 全新项目首次启动，且适合 planner / reviewer / implementer 长时间协作。

**限制：**
- 只作为项目启动模式，不作为普通任务升级路径。
- 项目已在 `quick-fix` 或 `spec-driven-full` 下开始后，不再切到 `superteam`。

---

## 四、模式怎么选

```text
主 agent 能单轮闭环，且没有持久 task 状态、delegated implementation、并行写入域？
├── 是 -> quick-fix
└── 否 -> spec-driven-full

全新项目首次启动，且适合长时间多 agent 自动协作？
└── 才考虑 superteam
```

`quick-fix` 和 `spec-driven-full` 都不是“轻 vs 重”的身份标签，而是不同的执行组织方式。前者靠主 agent 闭环，后者靠可派发 task 闭环。

---

## 五、Plan 与 Task 怎么写

### Plan

Plan 不需要复杂图表，但必须写清执行拓扑：

- 哪些任务形成串行链。
- 哪些任务属于可并行组。
- 同一并行组的写入域必须不交叉。
- 每组任务的验证策略和风险。

这样主线程可以一眼看出哪些 task 能在同一轮并发派发，哪些必须等依赖完成。

### Task

Formal task 文档必须包含两个 agent 可执行性字段：

- `Inputs`：冷启动需要的上下文，包括文件路径、依赖 task 的产出、相关 spec / plan 链接。
- `Return contract`：期望返回格式，例如 diff、文件清单、验证结果、风险摘要和 bounded summary。

这两个字段让“写 task”和“派 delegated agent”成为同一个动作。

---

## 六、关键规则速查

### Git 工作流

- `main` 保持稳定，`dev` 作为非平凡工作的集成分支。
- task branch 从 `dev` 切出，完成验证和 review 后回到 `dev`。
- 如果已经在匹配当前目标的 task branch 上，继续使用该分支；否则从最新 `dev` 切出。
- task branch 合入 `dev` 后，需要按风险重新验证集成状态。
- 只有当 `dev` 的集成状态已验证，才提升到 `main`。
- 从 `main` 发出的紧急修复，需要合并或 cherry-pick 回 `dev`。
- 当 `main`、`dev` 或多个 task branch 需要并行驻留时，优先使用 `git worktree`。

### 测试（`testing.md`）

- 可测试的代码 task 默认遵循 TDD。
- 测试要求必须在 task 中先写清楚。
- 如果 test-first 不适合该任务，必须先写清验证方式。
- 验证顺序固定为 `unit -> integration -> e2e`。
- 测试范围随风险和影响面扩大。

### 代码审查（`code-review.md`）

- 明确 review、已有 task-scoped diff，或改动涉及公共契约、共享模块、持久化、安全、数据丢失风险、跨模块行为、用户可见流程时，走完整 review loop。
- review 只提供本任务相关 diff；无关 dirty files 单独列出，除非用户要求，不审查也不修改。
- 使用当前 agent 环境可用的 native review workflow。
- 如果没有 native review command，就做 manual code-review pass 并说明限制。
- 最多迭代 3 轮，优先处理 bug、回归、缺测试、安全或契约漂移。
- 小型 quick-fix 仍需 self-review、验证和简洁 diff summary。

### 委派（`delegation.md`）

使用 delegated agent 的常见信号：

- 上下文压力接近压缩。
- 工作跨多个模块或需要广泛探索。
- 工作可拆成独立 read / implementation / verification / review slices。
- `SESSION_HANDOFF.md` 会变成“待读文件列表”而不是消化结论。

不要委派主线程立即阻塞的下一步。并行 worker 的写入域必须不交叉，除非主线程显式串行化。
并行 worker 的写入域应在所属 task 里先声明，不在派发时临时决定。

### Context Economy

- 派发时给 task 文档和直接输入路径，不塞整份 plan。
- delegated agent 返回消化后的结果，主线程默认整合结果，不重复读取它探索过的上下文。
- `TASKS.md` 是唯一轻量共享协调板，并由主线程独写。

### SESSION_HANDOFF

`SESSION_HANDOFF.md` 只存 transient state。多 agent 场景下，每个未完成 delegated task 要记录：

- 启动指令。
- 输入路径。
- 预期产出。
- 当前状态。

目标是下次会话能直接重派，而不是重新思考任务边界。

---

## 七、文档归属

- `CLAUDE.md` / `AGENTS.md`：全局或项目级 baseline、命令、路径和约束。
- `rules/*.md`：长期稳定的领域规则。
- `docs/specs/spec-<slug>.md`：需求和验收标准。
- `docs/plans/<slug>/plan.md`：路线、拓扑、依赖、风险和测试策略。
- `docs/plans/<slug>/tasks/task-<nnn>-<slug>.md`：执行范围、Inputs、Return contract、测试和文档更新。
- `TASKS.md`：当前焦点、优先级、阻塞、delegation board 和下一步动作。
- `SESSION_HANDOFF.md`：会话续接状态，不替代 spec / plan / task。
- `SURFACE.md`：真实公共契约。

---

## 八、常见反模式

| 反模式 | 解释 | 应对 |
|---|---|---|
| `CLAUDE.md` 和 `AGENTS.md` 写成两套语境 | 同一项目被不同 agent 读出不同规则 | 使用 agent-neutral 表述 |
| 把 `TASKS.md` 当 spec 用 | 导航板里塞详细需求 | TASKS.md 只放轻量状态和下一步 |
| Plan 不标注并行关系 | 主线程不知道能否并发派发 | 写清串行链与并行组 |
| Task 缺少 `Inputs` | delegated agent 冷启动要重新探索 | 把文件路径和依赖产出写进 task |
| Task 缺少 `Return contract` | delegated agent 返回不可整合 | 预先规定 diff、文件清单、验证和摘要 |
| 把整个 plan 塞给 delegated agent | 浪费 token 且扩大歧义 | 只给 task 文档和直接输入路径 |
| 让 delegated agent 干阻塞下一步 | 主线程空等 | 阻塞工作由主线程处理或显式串行化 |
| 规则越写越细 | 用兜底条款代替判断 | 保持规则短，模糊时问一个关键问题 |

---

## 九、维护原则

- 规则写行为，不写长理由。
- 能镜像的 Claude / Codex 规则使用 symlink 单源维护；修改时只改 `claude/`。
- `codex/` 下的规则入口只用于路径兼容，安装到 `$HOME` 时由 `restore.sh` 直接链接到 `claude/` 单源。
- 平台差异使用中性表达，不复制两套心智模型。
- 每条新规则都应改变真实决策，否则不加。
- 文档服务于执行，不服务于仪式感。

---

## 附录：实际规则文件

实际规则文件安装到 `~/.claude/` 和 `~/.codex/`；dotfiles 中的维护入口是 `claude/`，Codex 侧同名文件通过 symlink 镜像。运行 `scripts/restore.sh` 后，`~/.codex/AGENTS.md` 和 `~/.codex/rules/*.md` 会直接指向 `claude/` 单源：

- `CLAUDE.md` / `AGENTS.md`：全局基线、commit 规范、workflow 和 review 入口。
- `rules/planning.md`：模式路由、spec / plan / task 字段、superteam 条件。
- `rules/testing.md`：TDD 和验证顺序。
- `rules/code-review.md`：review 循环与收敛。
- `rules/documentation.md`：文档归属、TASKS、SESSION_HANDOFF、SURFACE。
- `rules/delegation.md`：delegated agent 协议和 Context Economy。
- `rules/architecture.md`：架构边界和公共契约。
- `rules/english.md`：英文纠错激活条件。
