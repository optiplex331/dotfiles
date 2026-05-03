# Documentation Memory

## Write-Back

Documentation updates are part of implementation. Update related docs in the
same task when any of these change:

- Behavior.
- Interfaces.
- Workflows.
- Acceptance criteria.
- Public contracts.
- Constraints or assumptions.
- Usage or operational commands.

## Ownership

| Document | Owns |
| --- | --- |
| Global `CLAUDE.md` / `AGENTS.md` | Concise baseline and Trellis pointers |
| Project `CLAUDE.md` / `AGENTS.md` | Project workflow, commands, paths, constraints |
| `.trellis/spec/` | Durable conventions and reusable lessons |
| `.trellis/tasks/` | Task PRDs, context manifests, research, and task state |
| `.trellis/workspace/` | Per-developer journals and session memory |
| `TASKS.md` | Current focus, priority, blockers, delegation board, next action |
| `SESSION_HANDOFF.md` | Transient continuation state |
| `SURFACE.md` | Public contracts |

`TASKS.md`, `SESSION_HANDOFF.md`, and `SURFACE.md` do not replace Trellis task
or spec files.

## Continuity

Preserve digested conclusions, not only file paths or commands. Record durable
lessons in `.trellis/spec/`; record task-specific facts in `.trellis/tasks/`;
record session continuity in `.trellis/workspace/<developer>/`.

Create `SESSION_HANDOFF.md` only when the next action must survive context loss
outside the Trellis task/journal system.
