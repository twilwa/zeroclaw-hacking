## ADDED Requirements

### Requirement: Zeroclaw shall parse OpenClaw frontmatter from `SKILL.md`

When a skill directory contains `SKILL.md` and does not contain `SKILL.toml`,
`zeroclaw` SHALL parse YAML frontmatter before loading the markdown body.

#### Scenario: Frontmatter skill loads structured metadata

- **WHEN** `zeroclaw` loads a markdown skill with valid OpenClaw frontmatter
- **THEN** the resulting skill model includes supported fields such as `name`,
  `description`, `homepage`, invocation policy, and OpenClaw metadata

### Requirement: `SKILL.toml` shall keep precedence over markdown frontmatter

Existing `SKILL.toml` behavior SHALL remain authoritative when both TOML and
markdown skill definitions are present.

#### Scenario: TOML wins over markdown

- **WHEN** a skill directory contains both `SKILL.toml` and `SKILL.md`
- **THEN** `zeroclaw` loads the TOML definition instead of the markdown
  frontmatter definition

### Requirement: Zeroclaw shall gate OpenClaw markdown skills at load time

`zeroclaw` SHALL evaluate supported OpenClaw gating fields during skill loading:
`os`, `requires.bins`, `requires.anyBins`, `requires.env`, and
`requires.config`.

#### Scenario: Ineligible skill is skipped deterministically

- **WHEN** a markdown skill declares unmet runtime requirements
- **THEN** `zeroclaw` skips the skill
- **AND** logs a deterministic reason for the skip

### Requirement: Prompt injection shall respect invocation policy

`zeroclaw` SHALL exclude skills marked `disable-model-invocation = true` from
prompt injection while still retaining their metadata for explicit use or
inspection.

#### Scenario: Disabled model invocation is omitted from prompt text

- **WHEN** prompt construction runs with a loaded skill that disables model
  invocation
- **THEN** the skill does not appear in the model-facing skill prompt section

### Requirement: Unsupported OpenClaw command metadata shall stay inert

`zeroclaw` SHALL parse but not execute unsupported OpenClaw fields
`command-dispatch`, `command-tool`, `command-arg-mode`, and `install`.

#### Scenario: Unsupported fields are preserved without activation

- **WHEN** a markdown skill contains unsupported OpenClaw command metadata
- **THEN** `zeroclaw` preserves that metadata on the skill object
- **AND** logs that the fields are unsupported instead of executing them
