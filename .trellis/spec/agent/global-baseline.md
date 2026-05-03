# Global Baseline

## Purpose

The global agent baseline is a short entry point shared by Claude, Codex, and
other Trellis-capable tools. It should orient the agent, then defer detailed
behavior to Trellis specs and workflow files.

## Source Order

When working in a repository:

1. Follow system and platform instructions.
2. Read project `CLAUDE.md` / `AGENTS.md`.
3. If the repository has `.trellis/`, use `.trellis/workflow.md` and relevant
   `.trellis/spec/` files for task routing and implementation context.
4. If no project `.trellis/` exists, use the global Trellis baseline installed
   from this dotfiles repository at `~/.trellis/spec/agent/`.

## Entry File Rules

- Keep `CLAUDE.md` and `AGENTS.md` concise.
- Do not duplicate long workflow, review, delegation, or documentation rules in
  entry files.
- Entry files may name important paths and commands, but durable behavior belongs
  in `.trellis/spec/agent/` or project-local `.trellis/spec/`.
- Project rules may be stricter than the global baseline. They should not
  silently weaken it.

## Skill Routing

Use native platform skills and agents first. When Trellis is available in the
project, route non-trivial file-changing work through the Trellis task workflow.

Use direct answers for pure Q&A, explanation, lookup, or chat that does not
change files.
