# Planning Rules

## Mode Routing

Classify work before execution:

- `quick-fix`: bounded, explicit, low-ambiguity fixes or small local updates.
- `spec-driven-full`: default for new features, medium-or-larger changes,
  meaningful ambiguity, or work that should be reviewed before code is written.
- `superteam`: optional standalone project mode for brand-new, large,
  long-running work suited to planner/reviewer/implementer automation.

## Quick Fix

Default route:

`think/hunt -> build -> check -> docs update`

Rules:

- A lightweight written plan summary is required before coding.
- Full spec/plan/task documents are not required.
- Update related docs when behavior, workflow, assumptions, or usage change.

## Spec Driven Full Mode

Default route:

`spec -> plan -> task -> code -> unit -> integration -> e2e`

Rules:

- Spec must be approved before planning starts.
- Plan must be approved before task generation.
- Task must be approved before coding starts.
- Coding must stay inside the approved task boundary.

## Spec Rules

Each spec should cover:

- Background
- Goal
- Audience
- User scenarios
- Scope
- Non-goals
- Constraints
- Edge cases
- Acceptance criteria
- Open questions

Rules:

- Spec does not generate tasks.
- Acceptance criteria must be judgeable.
- Spec must be approved before planning starts.

## Plan Rules

Each plan should:

- Reference the approved spec.
- Explain implementation strategy.
- Define workstreams and dependency order.
- Call out risks.
- Define the test strategy.
- Define task breakdown rules.

Rules:

- Plan must be approved before task generation.
- Tasks must structurally belong to the plan that owns them.
- Plan should keep tasks small enough for independent review and rollback.

## Task Rules

Each task must include:

- Status
- References
- Dependencies
- Objective
- In scope
- Out of scope
- Checklist
- Acceptance criteria
- Test requirements
- Documentation updates
- Notes / risks

Rules:

- One task, one clear objective.
- One task, one reviewable unit.
- One task, one commit when feasible.
- A task must be independently testable and revertible.
- Coding must stay inside the approved task boundary.

## Superteam Entry Conditions

Route to `superteam` only when the task is:

- The first workflow choice for a brand-new project.
- Large enough to span many tasks.
- Suitable for long unattended execution.
- Better served by planner/reviewer/implementer automation than normal
  interactive review.

Do not route to `superteam` when:

- Project work has already started in `quick-fix` or `spec-driven-full`.
- The user wants to upgrade an existing project into a heavier mode.
- The request is only a subproject, milestone, or new phase inside an existing
  project.
