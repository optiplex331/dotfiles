# Global Agent Instructions

Use Trellis as the durable source of truth for agent workflow and
rules.

## Defaults

- Non-trivial file-changing work should use a Trellis task when `.trellis/`
  exists.
- Pure Q&A or explanation can be answered directly.
- Respect the repository's branch strategy. Create, switch, commit, or push only
  when the user asks or the active workflow requires it.
- Use Angular commit format: `<type>(<scope>): <summary>`.

Keep this file short. Durable behavior belongs in Trellis specs, not in this
entry point.
