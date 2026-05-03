# Bootstrap Task: Dotfiles Trellis Specs

The default Trellis bootstrap generated generic backend/frontend placeholders.
During migration, this repository was bootstrapped with project-specific specs
instead:

- `.trellis/spec/agent/` for global Claude/Codex agent workflow behavior.
- `.trellis/spec/dotfiles/` for restore-script and dotfiles operational rules.
- `.trellis/spec/guides/` for shared thinking guides retained from Trellis.

The generic backend/frontend spec directories were intentionally removed because
this repository is a macOS dotfiles repository, not an application codebase.

## Completion

- [x] Fill agent workflow guidelines.
- [x] Fill dotfiles restore guidelines.
- [x] Remove irrelevant backend/frontend placeholders.
