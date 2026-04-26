# Architecture Rules

Use this guide when a task changes module boundaries, public interfaces, storage
formats, deployment assumptions, or cross-component contracts.

## Principles

- Prefer existing project patterns over new abstractions.
- Add an abstraction only when it removes real complexity, reduces meaningful
  duplication, or matches an established local pattern.
- Keep changes scoped to the approved task boundary.
- Update the governing spec, plan, or task before coding when implementation
  reveals a new constraint, edge case, or conflict.

## Public Contracts

Enable or update `SURFACE.md` only when the project exposes a real public
boundary, such as:

- HTTP APIs
- SDK interfaces
- Plugin protocols
- Event or schema contracts

Do not create `SURFACE.md` for internal-only implementation details.
