# Agent 规则系统 · 上手指南

> 面向：刚接触这套 `~/.claude/` / `~/.codex/` 共享规则系统的开发者。
> 目标：理解如何用同一套规则指导 Claude Code、Codex 等 agentic coding tools，并把日常项目工作拆到多 agent 可协作的粒度。

---

## 一、这是什么

这是一套全局 agent 规则系统，用来约束不同编码 agent 在项目里的工作方式。它解决的核心问题是：

- 同类任务的执行方式不稳定。
- `CLAUDE.md` / `AGENTS.md` 容易各写一套，形成两种语境。
- 任务要么直接动手、缺少交接面，要么流程过重、难以执行。

这套系统的回答是：**用少量调度规则把工作切成可闭环、可验证、可 review、可交接的 agent 执行单元。**

每个 rule 尽量只回答三件事：什么时候触发、谁负责、怎样关闭。

---

## 二、文件结构

Claude 与 Codex 使用同构文件：

```text
~/.claude/
├── CLAUDE.md
└── rules/
    ├── planning.md
    ├── code-review.md
    ├── documentation.md
    ├── delegation.md
    └── english.md

~/.codex/
├── AGENTS.md
└── rules/
    ├── planning.md
    ├── code-review.md
    ├── documentation.md
    ├── delegation.md
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
- 主 agent 能在一个 bounded round 中完成探索、实现、验证和文档更新。
- 不需要持久 spec / plan / task / task-board state。
- 不需要 delegated task ownership 或计划内并行写入域。
- 开始前给轻量计划，结束时给验证结果和简洁 diff summary。
- quick-fix 可以使用 submission-style delegation，但主 agent 必须在同一轮中吸收和验证结果。
- 如果发现需要 durable state、delegated task ownership 或计划内并行写入域，改走 `spec-driven-full`。

### 2. `spec-driven-full`

**适用：** 需要拆成 agent-sized tasks 的任务。

**流程：** `spec -> plan -> task -> code -> unit -> integration -> e2e`

**关键纪律：**
- Spec 对齐目标和验收标准。
- Plan 标注串行链与可并行 task 组。
- 多 agent 写代码前先确定每个 task 的 branch / worktree 策略。
- Task 必须能被主线程或 delegated agent 冷启动执行。
- Plan 或 owning task 决定执行 owner，不在派发时临时决定。
- 编码必须留在已批准 task 范围内。

### 3. `superteam`

**适用：** 全新项目首次启动，且适合 planner / reviewer / implementer 长时间协作。

**限制：**
- 只作为项目启动模式，不作为普通任务升级路径。
- 项目已在 `quick-fix` 或 `spec-driven-full` 下开始后，不再切到 `superteam`。

---

## 四、模式怎么选

```text
主 agent 能单轮闭环，且没有持久 task 状态、delegated task ownership、计划内并行写入域？
├── 是 -> quick-fix
└── 否 -> spec-driven-full

全新项目首次启动，且适合长时间多 agent 自动协作？
└── 才考虑 superteam
```

`quick-fix` 和 `spec-driven-full` 都不是“轻 vs 重”的身份标签，而是不同的执行组织方式。前者靠主 agent 闭环，后者靠可派发 task 闭环。

---

## 五、Plan 与 Task 怎么写

### Plan

Plan 是执行拓扑，不是长解释。它必须写清：

- 哪些任务形成串行链。
- 哪些任务属于可并行组。
- 同一并行组的写入域必须不交叉。
- 每组任务的验证策略和风险。

这样主线程可以一眼看出哪些 task 能并发派发，哪些必须等依赖完成。

### Task

Formal task 是一个可执行单元。它必须包含两个 agent 可执行性字段：

- `Inputs`：冷启动需要的上下文，包括文件路径、依赖 task 的产出、相关 spec / plan 链接。
- `Return contract`：期望返回格式，例如 diff、文件清单、验证结果、风险摘要和 bounded summary。

这两个字段让 task 可以被主线程或 delegated agent 冷启动执行，执行 owner 由 plan 或 owning task 决定。

Formal task 收尾时必须把完成事实写回完整：

- Task 自己负责 checklist、验收标准和验证结果。
- Plan 负责跨 task 进度、依赖解锁和风险变化。
- Spec-level open question、scope、constraint 或 acceptance criteria 被解析或改变时，回写 spec。
- `done` task 不能留下未解释的空 checkbox；不适用就写 `N/A` 原因，移出范围就指向 follow-up。
- Plan 要有覆盖所有 formal tasks 的 `Progress` 或等价任务表。
- Spec 的 `Open questions` 要保留原始问题文本，并追加状态和答案：`[RESOLVED <date>] 原问题 — 答案` / `[DEFERRED <date>] 原问题 — owner 或下一触发条件`。

一个 task 不能只把 `Status` 改成 done 就结束；task 文档和所属 plan 必须对同一个完成事实达成一致。

---

## 六、关键规则速查

### Git 工作流

提交信息使用 Angular Commit Message Convention：`<type>(<scope>): <summary>`。
类型限制为 `feat` `fix` `docs` `refactor` `perf` `test` `build` `ci` `chore` `revert`；summary 用英文祈使句，不加句号，最长 72 字符。

- `main` 保持稳定，`dev` 作为非平凡工作的集成分支。
- 非平凡编辑开始前，使用匹配当前目标的 task branch；否则从最新 `dev` 切出。
- task branch 完成验证和 review 后合回 `dev`。
- 合入后重新验证 `dev`，只有集成状态已验证，才提升到 `main`。
- 从 `main` 发出的紧急修复，需要合并或 cherry-pick 回 `dev`。
- branch 范围要和任务一致；同一任务的 code / docs 放在一起，范围变化就换新 branch。
- 提交新的未跟踪 config 或 env 文件前，先确认它应该入库还是留在本地 / ignore。
- 当 `main`、`dev` 或多个 task branch 需要并行驻留时，优先使用 `git worktree`。

### 规划与验证（`planning.md`）

- `planning.md` 只负责 workflow routing、spec / plan / task gates、task closure 和验证顺序。
- `quick-fix` 只有在主线程单轮可闭环、无 durable state、无 delegated task ownership、无计划内并行写入域时使用。
- 需要 durable state、delegated task ownership、计划内并行写入域或跨模块协调时进入 `spec-driven-full`。
- 可测试的代码 task 默认遵循 TDD。
- 测试要求必须在 task 中先写清楚。
- 如果 test-first 不适合该任务，必须先写清验证方式。
- 验证顺序固定为 `unit -> integration -> e2e`。
- 测试范围随风险和影响面扩大。

### 代码审查（`code-review.md`）

- code review 是风险门，不是默认长流程。
- 明确 review、已有 task-scoped diff，或改动涉及公共契约、共享模块、持久化、安全、数据丢失风险、跨模块行为、用户可见流程时，走完整 review loop。
- review 只提供本任务相关 diff；无关 dirty files 单独列出，除非用户要求，不审查也不修改。
- 使用当前 agent 环境可用的 native review workflow。
- 如果没有 native review command，就做 manual code-review pass 并说明限制。
- 最多迭代 3 轮，优先处理 bug、回归、缺测试、安全或契约漂移。
- 小型 quick-fix 仍需 self-review、验证和简洁 diff summary。

### 委派（`delegation.md`）

delegation 跟随 `planning.md` 选定的模式；它改变执行形态，不改变整体目标的 ownership，也不改变 spec / review / docs / verification gates。

核心边界不是“有没有 sub-agent”，而是 delegated agent 是提交 bounded result，还是拥有 engineering task。

QuickFix 中只允许 submission-style delegation：

- read-only scan。
- repeated check。
- candidate finding。
- reproduction attempt。
- verification attempt。
- alternative patch suggestion。

主 agent 保留完整任务、最终 diff、判断、整合、验证和交付；sub-agent 输出只是候选结果，不能拥有 durable task state、最终集成、全局决策或独立 reviewable implementation unit。

SpecDriven 中可以使用 task-ownership delegation：

- 主 agent 维护 orchestration、context hygiene、workflow gates、task graph、依赖顺序、集成判断、验证状态和 handoff。
- delegated agent 拥有一个 bounded task，使用 task 中声明的 inputs、read scope、write scope、acceptance criteria、verification requirements 和 return contract。

避免委派：

- 主线程立即阻塞且无法继续做有用工作的下一步。
- 主线程能更快本地闭环的一文件小修。
- 需要全局产品、架构或流程判断的决策。
- read scope、write scope 或 expected output 不清楚的工作。

QuickFix submission 使用轻量 contract：`Goal` / `Scope` / `Return`。SpecDriven task 使用 `planning.md` 定义的 task fields。

### Context Economy

- 派发时给短 contract、task 文档和直接输入路径，不塞整份 plan。
- delegated agent 返回消化后的结果，主线程默认整合结果，不重复读取它探索过的上下文。
- coordination state 写回 `documentation.md` 定义的归属文件。

### 英文辅助（`english.md`）

- 只在用户写英文 prose 且有重要语法或措辞错误时触发。
- 跳过中文消息、代码、日志、路径、命令、identifier 和引用文本。
- 纠错放在回复末尾，保持短、轻、友好。

### 文档归属

- `CLAUDE.md` / `AGENTS.md`：全局或项目级 baseline、命令、路径和约束。
- `rules/*.md`：长期稳定的领域规则。
- `docs/specs/spec-<slug>.md`：需求和验收标准。
- `docs/plans/<slug>/plan.md`：路线、拓扑、依赖、风险和测试策略。
- `docs/plans/<slug>/tasks/task-<nnn>-<slug>.md`：执行范围、Inputs、Return contract、测试和文档更新。
- `TASKS.md`：当前焦点、优先级、阻塞、delegation board 和下一步动作。
- `SESSION_HANDOFF.md`：会话续接状态，不替代 spec / plan / task。
- `SURFACE.md`：真实公共契约。

`documentation.md` 只管事实写回哪里，不重新定义 task closure gate。`SESSION_HANDOFF.md` 和压缩摘要只保存续接所需的 transient state，不替代 spec / plan / task / `TASKS.md`。它们要保存消化后的结论，而不只是文件路径、命令或“下次重读这里”的指针。

当上下文需要压缩或 handoff 时，按优先级保留：

1. 架构决策和背后的理由。
2. 改过哪些文件、每个文件改了什么。
3. 当前进展状态。
4. 还没做完的 TODO；如果有未完成的 delegated task，要包含启动指令、输入路径、预期产出和当前状态。

目标是下次会话能直接续接或重派，而不是重新思考任务边界。

只有项目暴露真实公共边界时才创建或更新 `SURFACE.md`，例如 HTTP API、SDK、plugin protocol、event 或 schema contract。内部实现细节不需要 `SURFACE.md`。

交付 artifact 前，只包含用户可见文档和必要 runtime / build 文件；通过 package allowlist 或 ignore / exclude 文件排除过程文档，不从 source tree 手动删除。如果过程文档内容要交给用户，先移动或复制到用户可见文档里。

---

## 七、常见反模式

| 反模式 | 解释 | 应对 |
|---|---|---|
| `CLAUDE.md` 和 `AGENTS.md` 写成两套语境 | 同一项目被不同 agent 读出不同规则 | 使用 agent-neutral 表述 |
| 把 `TASKS.md` 当 spec 用 | 导航板里塞详细需求 | TASKS.md 只放轻量状态和下一步 |
| Plan 不标注并行关系 | 主线程不知道能否并发派发 | 写清串行链与并行组 |
| Task 缺少 `Inputs` | delegated agent 冷启动要重新探索 | 把文件路径和依赖产出写进 task |
| Task 缺少 `Return contract` | delegated agent 返回不可整合 | 预先规定 diff、文件清单、验证和摘要 |
| 把整个 plan 塞给 delegated agent | 浪费 token 且扩大歧义 | 只给 task 文档和直接输入路径 |
| 让 delegated agent 干阻塞下一步 | 主线程空等 | 阻塞工作由主线程处理或显式串行化 |
| Rule 写成长解释 | 读起来对，临场仍然不知道怎么做 | 改成 trigger / owner / closure |
| 规则越写越细 | 用兜底条款代替判断 | 保持规则短，模糊时问一个关键问题 |

---

## 八、维护原则

- 规则写行为，不写长理由。
- 能镜像的 Claude / Codex 规则使用 symlink 单源维护；修改时只改 `claude/`。
- `codex/` 下的规则入口只用于路径兼容，安装到 `$HOME` 时由 `restore.sh` 直接链接到 `claude/` 单源。
- 平台差异使用中性表达，不复制两套心智模型。
- 每条新规则都应改变真实决策，否则不加。
- 文档服务于执行，不服务于仪式感。

---

## 附录：实际规则文件

实际规则文件安装到 `~/.claude/` 和 `~/.codex/`；dotfiles 中的维护入口是 `claude/`，Codex 侧同名文件通过 symlink 镜像。运行 `scripts/restore.sh` 后，`~/.codex/AGENTS.md` 和 `~/.codex/rules/*.md` 会直接指向 `claude/` 单源：

- `CLAUDE.md` / `AGENTS.md`：全局基线、commit 规范、rule loading 和入口路由。
- `rules/planning.md`：workflow routing、spec / plan / task gates、task closure、验证顺序。
- `rules/code-review.md`：review trigger、review loop、finding priority、closure。
- `rules/documentation.md`：文档归属、write-back、TASKS、SESSION_HANDOFF、SURFACE。
- `rules/delegation.md`：mode-specific delegated-agent permissions、dispatch contract、result contract、parallel constraints。
- `rules/english.md`：英文纠错 trigger、skip conditions、output format。
