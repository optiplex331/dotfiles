# Agent 规则系统 · Trellis 版上手指南

> 面向：刚接触这套 dotfiles agent workflow 的开发者。
> 目标：理解 Claude、Codex 和 `.agents/skills` 如何共用 Trellis 的任务、规范和记忆系统。

---

## 一、这是什么

这套系统已经从旧的 `~/.claude/rules/*.md` / `~/.codex/rules/*.md` 迁移到
Trellis。新的核心是：

- `.trellis/workflow.md`：任务生命周期、状态注入和路由规则。
- `.trellis/spec/agent/`：全局 agent 行为规范。
- `.trellis/spec/dotfiles/`：dotfiles 仓库操作规范。
- `.trellis/tasks/`：每个任务的 PRD、上下文 manifest、research 和状态。
- `.trellis/workspace/`：开发者 journal 与跨会话记忆。
- `.claude/`、`.codex/`、`.agents/skills/`：Trellis 生成的平台适配层。

旧系统的问题是 Claude 和 Codex 各自安装一套规则文件，虽然内容尽量镜像，
但维护时仍然容易分叉。Trellis 版把 durable rules 放到 `.trellis/spec/`，
平台入口只负责指路。

---

## 二、安装后文件结构

`scripts/restore.sh` 会把关键入口安装到 `$HOME`：

```text
~/.trellis/                         # Trellis specs, tasks, workflow, workspace
~/.claude/CLAUDE.md                 # 短入口，指向 Trellis
~/.claude/agents/trellis-*.md       # Claude Trellis sub-agents
~/.claude/commands/trellis/         # Claude Trellis commands
~/.claude/skills/trellis-*/         # Claude Trellis skills
~/.codex/AGENTS.md                  # 短入口，指向 Trellis
~/.codex/agents/trellis-*.toml      # Codex Trellis sub-agents
~/.agents/skills/trellis-*/         # Codex / compatible tools shared skills
```

`~/.claude/rules/` 和 `~/.codex/rules/` 不再是 source of truth。restore 会删除
已知旧规则文件名的 symlink（包括旧的 workflow / skill-routing 入口），但不会删除
真实目录，避免误伤手工维护的本地文件。

---

## 三、日常工作流

在已经初始化 Trellis 的项目里：

```bash
# 查看可用 spec
python3 ./.trellis/scripts/get_context.py --mode packages

# 创建任务
python3 ./.trellis/scripts/task.py create "Task title" --slug task-slug

# 校验 implement/check context
python3 ./.trellis/scripts/task.py validate <task-dir>

# 激活任务
python3 ./.trellis/scripts/task.py start <task-dir>
```

纯问答可以直接回答。非平凡文件修改默认进入 Trellis task：先写 `prd.md`，
再维护 `implement.jsonl` / `check.jsonl`，然后实现、检查、更新 spec、提交。

---

## 四、规范放哪里

| 内容 | 新位置 |
| --- | --- |
| 全局入口规则 | `.trellis/spec/agent/global-baseline.md` |
| Git / branch / commit | `.trellis/spec/agent/git-and-branching.md` |
| Workflow routing | `.trellis/spec/agent/workflow-routing.md` |
| Review / verification | `.trellis/spec/agent/review-and-verification.md` |
| Docs / memory / handoff | `.trellis/spec/agent/documentation-memory.md` |
| Delegation | `.trellis/spec/agent/delegation.md` |
| English coaching | `.trellis/spec/agent/english-coaching.md` |
| Dotfiles restore rules | `.trellis/spec/dotfiles/index.md` |

新规则只有在会改变真实 agent 决策时才加入 spec。一次性任务细节放在
`.trellis/tasks/<task>/`，不要写进 durable spec。

---

## 五、维护原则

- 入口短，规则进 spec。
- 任务事实进 `.trellis/tasks/`，长期经验进 `.trellis/spec/`。
- 平台差异留在 `.claude/`、`.codex/`、`.agents/skills/` adapter。
- 不手改 npm cache 或全局 Trellis 安装，修改 repo 内生成文件。
- `restore.sh` 只安装全局入口与显式可复用的 Trellis assets，不安装全局
  Claude/Codex hooks；项目级 hooks 由各项目自己的 `.claude/` / `.codex/`
  管理。

这版的要点很简单：**Claude 和 Codex 不再各背一套规则；它们都读 Trellis。**
