## 1. Repo hygiene and deployment safety

- [ ] 1.1 Rebuild `.gitmodules` to the intended submodule set and remove the
      orphan `--force` gitlink from the index.
- [ ] 1.2 Sync submodule metadata and verify `git submodule status` succeeds.
- [ ] 1.3 Replace tracked plaintext W&B secret usage in
      `phoneclaw-research/.mcp.json` with runtime environment loading.
- [ ] 1.4 Update phoneclaw launch and deployment docs or scripts to document
      `autonomy.shell_env_passthrough = ["WANDB_API_KEY"]`.

## 2. OpenClaw skill compatibility

- [ ] 2.1 Add failing tests for `SKILL.md` frontmatter parsing, runtime gating,
      and `disable-model-invocation`.
- [ ] 2.2 Extend the `Skill` model and `load_skill_md()` to parse OpenClaw
      frontmatter while preserving `SKILL.toml` precedence.
- [ ] 2.3 Implement load-time gating for `os`, `requires.bins`,
      `requires.anyBins`, `requires.env`, and `requires.config` with
      deterministic skip logging.
- [ ] 2.4 Exclude `disable-model-invocation = true` skills from prompt
      injection and keep unsupported command metadata visible but inactive.

## 3. Remote MCP tool support

- [ ] 3.1 Add failing tests for remote MCP tool listing, calling, timeout
      handling, and partial startup failure.
- [ ] 3.2 Extend config schema with `[mcp]` and `[[mcp.servers]]`.
- [ ] 3.3 Implement streamable-HTTP MCP client registration as `server.tool`
      wrappers over the existing `Tool` trait.
- [ ] 3.4 Wire remote-tool registration into startup without blocking local
      tool boot on remote failures.

## 4. Skillforge trace mining

- [ ] 4.1 Add failing tests for `forge.db` schema creation, approval-state
      enforcement, and draft output paths.
- [ ] 4.2 Extend config schema with `[skillforge]` defaults and file locations.
- [ ] 4.3 Repurpose `skillforge` storage and workflow around `trace_runs`,
      `trace_steps`, `skill_candidates`, and `skill_deployments`.
- [ ] 4.4 Emit draft skills under `scratchpad/skills-drafts/` and require the
      `draft -> reviewed -> approved -> integrated` transition path.

## 5. Verification and review

- [ ] 5.1 Run targeted verification for repo hygiene, skill loading, MCP tools,
      and skillforge persistence.
- [ ] 5.2 Run the full required Rust checks for touched zeroclaw modules.
- [ ] 5.3 Review the final delta with `sem diff` when available and record any
      remaining blockers or follow-up work.
