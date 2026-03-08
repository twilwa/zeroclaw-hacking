# PhoneClaw research

This workspace holds planning and deployment notes for the phone-hosted
zeroclaw/OpenClaw integration work.

## W&B trace auth

Load `WANDB_API_KEY` from an untracked env file instead of embedding it in
tracked config.

1. Copy `phoneclaw-research/.env.example` to a local file such as
   `phoneclaw-research/.env.local`.
2. Set your real `WANDB_API_KEY` in that local file.
3. Source the file before launching local MCP tooling, for example:
   `set -a; . ./phoneclaw-research/.env.local; set +a`.
4. Add the passthrough in zeroclaw config:

```toml
[autonomy]
shell_env_passthrough = ["WANDB_API_KEY"]
```

For rooted phone deployment, place the same variable in `/data/local/zeroclaw.env`.
The startup scripts in `scratchpad/` load that file before starting zeroclaw.
