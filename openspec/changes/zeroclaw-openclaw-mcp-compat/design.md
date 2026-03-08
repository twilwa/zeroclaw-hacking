## Context

The controlling research brief is
`phoneclaw-research/scratchpad/zeroclaw-mcp-openclaw-integration-research-supplement.md`.
That brief narrows the target to four concrete outcomes: fix repository hygiene,
make `zeroclaw` consume OpenClaw skill metadata, add native HTTP MCP client
support, and turn the existing `skillforge` module into a local trace-mining
loop. The same brief also constrains sediment to a host-side role because the
current sediment server is stdio-only and its release footprint is not suitable
for the phone path.

Current state:

- Root `.gitmodules` is conflicted and the index still contains an orphan
  `--force` gitlink.
- `phoneclaw-research/.mcp.json` includes a tracked W&B key and must be treated
  as compromised.
- `zeroclaw` already supports `autonomy.shell_env_passthrough`.
- `zeroclaw` loads `SKILL.toml` and raw markdown skills, but it does not parse
  YAML frontmatter or evaluate OpenClaw-style skill gating.
- Tool registration is local-only.
- `skillforge` already exists, but it is oriented around external scouting and
  auto-integration instead of local trace mining and approval.

## Goals / Non-Goals

**Goals:**

- Restore correct submodule metadata and remove the invalid `--force` entry.
- Remove tracked plaintext secret usage and move deployment guidance to runtime
  `WANDB_API_KEY` passthrough.
- Preserve `SKILL.toml` precedence while adding OpenClaw-compatible
  `SKILL.md` frontmatter parsing and runtime gating.
- Register remote MCP tools over streamable HTTP as `server.tool`.
- Keep remote MCP failures non-fatal so the local tool surface still boots.
- Store trace-mining state in `workspace/skillforge/forge.db` with explicit
  review states and draft output under `scratchpad/skills-drafts/`.

**Non-Goals:**

- Full OpenClaw slash-command parity.
- Stdio or SSE MCP transports in `zeroclaw` v1.
- Replacing `memory::Memory` with sediment or any other external store.
- On-device sediment deployment.
- Automatic activation of generated skills.

## Decisions

### Use a dedicated OpenSpec change with four new capabilities

This is a cross-cutting change touching repo metadata, docs, config, runtime
tooling, and persistence. A single change keeps the dependencies visible while
still splitting the behavioral contract into four capability specs.

Alternative considered:

- One umbrella spec. Rejected because it would blur the distinct behavior
  surfaces and make later archive/sync work noisy.

### Treat `.gitmodules` and the `--force` gitlink as the first code change

`git submodule status` is currently broken, which makes every later review and
verification step harder. The root fix is to rebuild `.gitmodules` to match the
intended submodule set and remove the orphan `--force` gitlink from the index.

Alternative considered:

- Leave the bad gitlink in place and only patch `.gitmodules`. Rejected because
  Git will still fail on the unmapped path.

### Use `autonomy.shell_env_passthrough` instead of adding new env plumbing

`zeroclaw` already exposes a validated passthrough allowlist that feeds shell
  and process tools after `env_clear()`. Reusing that surface avoids widening
  the trusted environment model and keeps the W&B fix in config and docs instead
  of runtime logic.

Alternative considered:

- Add a new provider-specific safe env list. Rejected because it duplicates an
  existing mechanism and encourages per-provider sprawl.

### Keep `SKILL.toml` precedence and add structured `SKILL.md` frontmatter

The least risky compatibility change is to keep the existing TOML-first
behavior, then parse `SKILL.md` only when TOML is absent. `SKILL.md` parsing
captures both supported and unsupported OpenClaw fields so the system can
behave explicitly without pretending to implement everything.

Alternative considered:

- Merge TOML and markdown sources. Rejected because precedence would become
  ambiguous and could change current behavior.

### Evaluate skill gating at load time

OpenClaw compatibility requires gating on host capabilities and config, but the
prompt must stay bounded. Load-time eligibility filtering gives deterministic
logs, avoids injecting unusable skills into prompts, and naturally supports
`disable-model-invocation`.

Alternative considered:

- Defer gating to prompt-build time. Rejected because it keeps unusable skills
  resident and complicates tool/prompt consistency.

### Add streamable-HTTP MCP only

The research brief is explicit: v1 should add native HTTP MCP support and leave
stdio-only servers such as sediment behind a host bridge. This keeps the first
remote-tool implementation narrow and aligned with constrained phone-hosted
deployment.

Alternative considered:

- Implement stdio and SSE at the same time. Rejected because it broadens the
  transport surface and test matrix without helping the phone path.

### Repurpose `skillforge` around a separate SQLite database

The trace-mining loop needs candidate history, approval states, and deployment
bookkeeping that do not belong in `brain.db`. A separate `forge.db` keeps the
existing memory subsystem stable and lets `skillforge` evolve independently.

Alternative considered:

- Reuse `brain.db`. Rejected because it couples two separate lifecycles and
  makes cleanup, migrations, and auditing harder.

## Risks / Trade-offs

- Remote MCP dependency churn from a new Rust crate or protocol adapter
  selection. → Keep the transport surface narrow and isolate the wrapper in a
  new tool module.
- Skill gating can accidentally hide existing markdown skills. → Preserve plain
  markdown behavior when no frontmatter exists and add regression tests.
- Config-path gating may become brittle if the schema changes. → Resolve dotted
  paths against serialized config with explicit `None` behavior and tests.
- Phone deployment docs may drift from actual launch scripts. → Update the
  scripts and docs together in the same change.
- Approval-state enforcement could be bypassed by old integration paths. →
  Route integration through a single state transition helper and assert allowed
  transitions in tests.

## Migration Plan

1. Repair `.gitmodules` and remove the orphan `--force` gitlink from the index.
2. Remove tracked W&B secret material and update phone launch/deployment docs to
   rely on runtime `WANDB_API_KEY`.
3. Add config schema support for `mcp` and `skillforge`.
4. Extend skill loading and prompt filtering with OpenClaw-compatible metadata.
5. Add remote MCP tool registration and execution.
6. Rework `skillforge` storage and draft workflow.
7. Run targeted tests for each slice, then full verification for the touched
   Rust surface.

Rollback:

- Revert the root metadata and `phoneclaw-research` edits if repo hygiene work
  causes issues.
- Disable `[mcp]` and `[skillforge]` in config to fall back to prior runtime
  behavior while keeping the code present.

## Open Questions

- Which MCP Rust crate integration path compiles cleanly against the current
  `zeroclaw` dependency graph.
- Whether any existing `skillforge` CLI or daemon hooks need to remain backward
  compatible with the old scouting semantics.
- Whether a dedicated host-side sediment bridge should live in this repo or in
  a separate helper project once the HTTP MCP path is proven.
