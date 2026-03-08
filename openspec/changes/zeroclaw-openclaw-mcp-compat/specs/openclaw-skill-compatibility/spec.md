## ADDED Requirements

### Requirement: Zeroclaw SHALL parse OpenClaw-style skill frontmatter
Zeroclaw SHALL parse YAML frontmatter from `SKILL.md` files and map supported
OpenClaw metadata into the skill model while preserving existing `SKILL.toml`
precedence.

#### Scenario: Frontmatter metadata is loaded from markdown skill
- **WHEN** a skill directory contains a `SKILL.md` file with YAML frontmatter
- **THEN** zeroclaw parses supported fields including `name`, `description`,
  `homepage`, invocation policy, and OpenClaw metadata
- **THEN** the markdown body remains available as skill content

#### Scenario: TOML metadata still wins
- **WHEN** a skill directory contains both `SKILL.toml` and `SKILL.md`
  frontmatter for the same property
- **THEN** zeroclaw keeps `SKILL.toml` precedence for that property

### Requirement: Zeroclaw SHALL gate skills before prompt exposure
Zeroclaw SHALL evaluate supported gating fields at skill-load time and exclude
ineligible skills from prompt exposure with deterministic log messages.

#### Scenario: Missing env or binary skips a skill
- **WHEN** a skill requires an env var or binary that is not available
- **THEN** zeroclaw skips loading that skill into the active skill set
- **THEN** zeroclaw logs a deterministic reason for the skip

#### Scenario: Config requirement is evaluated against runtime config
- **WHEN** a skill declares `requires.config`
- **THEN** zeroclaw resolves the dotted config path against the current config
  object
- **THEN** zeroclaw loads the skill only if the requirement is satisfied

### Requirement: Non-model-invocable skills SHALL stay out of prompt injection
Zeroclaw SHALL omit skills marked with
`disable-model-invocation = true` from model prompt injection while preserving
their parsed metadata.

#### Scenario: Disabled skill is not advertised to the model
- **WHEN** a loaded skill sets `disable-model-invocation = true`
- **THEN** zeroclaw does not include that skill in the injected skill prompt
- **THEN** the skill metadata remains available for operator visibility and
  future non-model uses

### Requirement: Unsupported OpenClaw command metadata SHALL be preserved but not executed
Zeroclaw SHALL parse `command-dispatch`, `command-tool`, `command-arg-mode`,
and `install` metadata, preserve it on the skill record, and treat it as
unsupported behavior in v1.

#### Scenario: Unsupported command metadata is explicit
- **WHEN** a skill contains unsupported command or install metadata
- **THEN** zeroclaw records the metadata on the parsed skill
- **THEN** zeroclaw does not execute the metadata
- **THEN** zeroclaw logs that the metadata is unsupported in v1
