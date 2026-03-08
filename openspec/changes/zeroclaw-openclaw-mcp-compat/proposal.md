## Why

`zeroclaw` already has the right shape for a phone-first agent, but it cannot
yet consume the broader OpenClaw skill ecosystem or register remote MCP tools
in a way that fits the rest of this repo. The current workspace also has repo
hygiene defects that block normal submodule operations and keep a tracked secret
in local research config.

## What Changes

- Repair root submodule metadata so the repository matches the intended
  OpenClaw-related submodule set and `git submodule` works again.
- Remove tracked plaintext W&B credential usage from `phoneclaw-research` and
  document runtime-only `WANDB_API_KEY` handling via
  `autonomy.shell_env_passthrough`.
- Add OpenClaw-compatible `SKILL.md` frontmatter parsing, metadata capture, and
  runtime gating to `zeroclaw` while preserving `SKILL.toml` precedence.
- Add native streamable-HTTP MCP client support to `zeroclaw` and register
  remote tools as `server.tool` without making startup depend on remote hosts.
- Repurpose `skillforge` around local trace mining, explicit approval states,
  and a dedicated `workspace/skillforge/forge.db` store.
- Document sediment as a host-side adjunct memory service behind a future
  stdio-to-HTTP bridge instead of part of the on-device critical path.

## Capabilities

### New Capabilities

- `phoneclaw-repo-hygiene`: Repository and deployment hygiene for submodules,
  secret handling, and phone-side environment passthrough.
- `openclaw-skill-compat`: OpenClaw-compatible `SKILL.md` loading, metadata
  parsing, gating, and prompt eligibility in `zeroclaw`.
- `zeroclaw-remote-mcp`: Native streamable-HTTP MCP client registration and
  invocation for remote tools in `zeroclaw`.
- `skillforge-trace-mining`: Local trace mining, approval workflow, and draft
  skill generation backed by `forge.db`.

### Modified Capabilities

- None.

## Impact

- Affects root repository metadata in `.gitmodules` and submodule index state.
- Affects `phoneclaw-research` launch and deployment docs plus tracked local
  MCP config.
- Affects `zeroclaw` config schema, skill loading, prompt construction, tool
  registration, and skillforge persistence.
- Introduces a new Rust dependency surface for remote MCP support.
- `br` task tracking could not be populated because `br` is not installed in
  this environment.
