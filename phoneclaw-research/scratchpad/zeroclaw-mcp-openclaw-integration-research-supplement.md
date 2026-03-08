# Supplement: zeroclaw OpenClaw compatibility implementation brief

This file is the controlling brief for the zeroclaw/OpenClaw compatibility
change in this repo.

## Summary

- Repair root `.gitmodules` so tracked gitlinks and submodule metadata match.
- Remove tracked plaintext secret usage and standardize W&B auth on
  `WANDB_API_KEY` plus `autonomy.shell_env_passthrough = ["WANDB_API_KEY"]`.
- Add OpenClaw-compatible `SKILL.md` frontmatter parsing and load-time gating
  in zeroclaw while preserving `SKILL.toml` precedence.
- Add native streamable-HTTP MCP remote tool registration in zeroclaw with
  non-fatal per-server startup behavior and namespaced tool names.
- Repurpose zeroclaw `skillforge` toward local trace mining backed by
  `workspace/skillforge/forge.db`.
- Keep sediment host-side only in v1 behind a stdio-to-HTTP bridge after
  zeroclaw lands HTTP MCP support.

## Deployment note

The approved env path is:

```toml
[autonomy]
shell_env_passthrough = ["WANDB_API_KEY"]
```

Phone startup scripts must source `/data/local/zeroclaw.env` before starting
zeroclaw so the daemon process has the variable available for the allowlist.
