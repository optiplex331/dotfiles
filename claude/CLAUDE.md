# Global Agent Instructions

This machine uses Trellis as the durable source of truth for agent workflow and
rules.

## Rule Loading

1. Follow system and platform instructions.
2. Follow the current repository's `CLAUDE.md` / `AGENTS.md`.
3. If the repository has `.trellis/`, use `.trellis/workflow.md` and relevant
   `.trellis/spec/` files for task routing, implementation context, review, and
   documentation write-back.
4. If the repository has no `.trellis/`, use the global baseline installed at
   `~/.trellis/spec/agent/`.

## Defaults

- Non-trivial file-changing work should use a Trellis task when `.trellis/`
  exists.
- Pure Q&A or explanation can be answered directly.
- Respect the repository's branch strategy. Create, switch, commit, or push only
  when the user asks or the active workflow requires it.
- Use Angular commit format: `<type>(<scope>): <summary>`.

Keep this file short. Durable behavior belongs in Trellis specs, not in this
entry point.
