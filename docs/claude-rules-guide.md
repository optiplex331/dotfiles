# Agent 规则系统 · 上手指南

面向刚接触这套 `~/.claude/` / `~/.codex/` 共享规则系统的开发者。

目标不是把工作流程变重，而是让 agent 工作稳定地闭环：能路由、能验证、能 review、能交接。

---

## 一、核心模型

这套规则只解决三个问题：

- 什么时候触发某类流程。
- 哪个文件或角色拥有事实。
- 任务怎样才算关闭。

全局入口保持短，细节放进 rule 文件。项目可以追加更具体的规则，但不能默默削弱全局 baseline。

---

## 二、文件结构

Claude 与 Codex 使用同一套语义入口：

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

dotfiles 中的维护单源是 `claude/CLAUDE.md` 和 `claude/rules/*.md`。`codex/AGENTS.md` 与 `codex/rules/*.md` 是 repo-local 兼容 symlink；`scripts/restore.sh` 会把安装后的 `~/.codex/AGENTS.md` 和 `~/.codex/rules/*.md` 直接链接到 Claude 单源。

文本应使用 agent-neutral 语境，例如 `current agent environment`，避免 Claude / Codex 各写一套心智模型。

---

## 三、规则加载顺序

执行前只读匹配当前任务的 rule 文件，并按顺序应用：

1. 全局 `~/.claude/CLAUDE.md` 或 `~/.codex/AGENTS.md`
2. 匹配的全局 `rules/*.md`
3. 项目 `CLAUDE.md` 或 `AGENTS.md`
4. 项目 rule 文件

冲突时走更严格的规则。项目要放宽全局规则，必须写明原因。

---

## 四、工作模式

### `quick-fix`

用于主 agent 能在一个 bounded round 内闭环的任务。

流程：

```text
think/hunt -> build -> check -> docs update
```

必须同时满足：

- 主 agent 能完成探索、实现、验证、review、文档更新和交付摘要。
- 不需要把决策、计划、进度、blocker、验证结果或下一步动作写成 durable execution state。
- delegation 只提交候选结果，不拥有工程任务或写入域。

### `spec-driven-full`

用于需要 durable execution state 或 agent-sized tasks 的任务。

流程：

```text
spec -> plan -> task -> code -> unit -> integration -> e2e
```

触发信号：

- 需要记录可恢复的决策、计划、任务进度、blocker、验证结果或 exact next action。
- delegated agent 要拥有 engineering task 或 write scope。
- 范围跨多个 reviewable units、public behavior 或 cross-module coordination。

### `superteam`

只用于全新、很大、长时间运行且适合 planner / reviewer / implementer 自动协作的工作。不要把已经在 `quick-fix` 或 `spec-driven-full` 中进行的任务切到 `superteam`。

---

## 五、Plan / Task 最小要求

Plan 是执行拓扑，不是长解释。它要写清：

- implementation strategy
- serial chains 与 parallel task groups
- 同一并行组的 disjoint write scopes
- risks 与 test strategy
- task breakdown rules

Task 是一个可执行单元。它要能冷启动、能测试、能回滚、能 review。最关键字段是：

- `Inputs`：启动所需上下文，包括文件路径和依赖产出。
- `Return contract`：期望返回的 diff、文件清单、验证结果、风险和摘要。

Formal task 关闭时，不能只改 `Status: done`。task、owning plan、受影响 spec 必须写回同一个完成事实。

---

## 六、五个 rule 的边界

| Rule | 只负责 |
| --- | --- |
| `planning.md` | 路由、spec/plan/task gate、task closure、验证顺序 |
| `code-review.md` | review trigger、review loop、finding priority、closure |
| `documentation.md` | 文档归属、write-back、continuity state、SURFACE / TASKS / handoff |
| `delegation.md` | delegated agent 是 submission 还是 task owner，以及 dispatch / result contract |
| `english.md` | 用户英文 prose 的轻量纠错 |

不要让一个 rule 重新定义另一个 rule 的 gate。比如 `documentation.md` 只说事实写回哪里，不重新定义 task closure；`delegation.md` 只说 delegation 如何发生，不决定 workflow mode。

---

## 七、Continuity State

Continuity state 是为了续接工作而必须保存的知识：决策、改过的文件、进度、blocker、验证结果、下一步动作。

落点：

- `TASKS.md`：当前焦点、优先级、blocker、delegation board、exact next action。
- `SESSION_HANDOFF.md`：跨 context / session / branch / worktree / agent 的临时续接状态。
- 压缩摘要：同样只保存消化后的结论。

如果没有这些状态任务就无法可靠续接，这本身就是 `spec-driven-full` 的路由信号。

保存顺序：

1. 架构决策和理由。
2. 改过哪些文件、每个文件改了什么。
3. 当前进展。
4. 未完成 TODO；delegated task 还要写启动指令、输入路径、预期产出和当前状态。

---

## 八、Review 与 Delegation

Review 是风险门，不是形式感。明确 review、已有 task-scoped diff，或改动涉及公共契约、共享模块、持久化、安全、数据丢失风险、跨模块行为、用户可见流程时，走完整 review loop。小型 quick-fix 也要 self-review、验证和 diff summary。

Delegation 的边界是 ownership：

- `quick-fix`：delegated agent 只能提交 read-only scan、candidate finding、verification attempt 等候选结果。
- `spec-driven-full`：delegated agent 可以拥有声明清楚的 bounded task。

主线程始终拥有最终判断、整合、验证和交付。

---

## 九、Git 工作流

- `main` 保持稳定，`dev` 是非平凡工作的集成分支。
- 非平凡编辑在匹配任务的 branch 上做，并从最新 `dev` 切出。
- task branch 通过验证和 review 后合回 `dev`。
- `dev` 集成后要重新验证，才能提升到 `main`。
- 紧急从 `main` 发出的修复要合并或 cherry-pick 回 `dev`。
- scope 变了就换 branch；同一任务的 code 和 docs 放一起。
- 新 untracked config / env 文件提交前先确认该入库还是 ignore。

提交信息使用 Angular 格式：

```text
<type>(<scope>): <summary>
```

类型：`feat` `fix` `docs` `refactor` `perf` `test` `build` `ci` `chore` `revert`。Summary 用英文祈使句，不加句号，最多 72 字符。

---

## 十、维护原则

- 规则写行为，不写长理由。
- 每条新规则都要改变真实决策，否则不加。
- 能由 `CLAUDE.md` / `AGENTS.md` 指向 rules 的内容，不复制到入口。
- 能由 guide 解释的背景，不塞进 rules。
- 能用 symlink 单源维护的，不复制两套文件。
- 平台差异用中性表达承载。
- 文档服务执行，不服务仪式感。

常见反模式：

| 反模式 | 应对 |
| --- | --- |
| `CLAUDE.md` 和 `AGENTS.md` 写成两套语境 | 使用 agent-neutral 表述 |
| 把 `TASKS.md` 当 spec 用 | `TASKS.md` 只放轻量状态和下一步 |
| 把 handoff 当压缩兜底 | 需要续接状态时先承认它是 durable execution state |
| Plan 不标注并行关系 | 写清串行链和并行组 |
| Task 缺少 `Inputs` 或 `Return contract` | 让 task 能冷启动、可验证、可整合 |
| 把整个 plan 塞给 delegated agent | 只给 task 文档和直接输入路径 |
| 让 delegated agent 干阻塞下一步 | 阻塞工作由主线程处理或显式串行化 |
| Rule 写成长解释 | 改成 trigger / owner / closure |
