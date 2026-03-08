## ADDED Requirements

### Requirement: Skillforge shall use a dedicated trace-mining database

`skillforge` SHALL persist trace-mining and deployment state in
`workspace/skillforge/forge.db` instead of `brain.db`.

#### Scenario: Forge database initializes required tables

- **WHEN** `skillforge` initializes its persistence layer
- **THEN** `forge.db` contains `trace_runs`, `trace_steps`,
  `skill_candidates`, and `skill_deployments`

### Requirement: Skillforge shall default to non-automatic integration

`skillforge.auto_integrate` SHALL default to `false`.

#### Scenario: Default config does not auto-deploy

- **WHEN** `zeroclaw` starts with default `skillforge` config
- **THEN** generated candidates are not integrated automatically

### Requirement: Skillforge shall enforce approval states before integration

Generated skills SHALL move through the explicit state machine `draft ->
reviewed -> approved -> integrated`.

#### Scenario: Unapproved candidate cannot integrate

- **WHEN** a candidate has not reached the `approved` state
- **THEN** `skillforge` refuses to copy it into the active skill directory

### Requirement: Skillforge shall write draft skills to scratchpad output

Generated draft skills SHALL be written to `scratchpad/skills-drafts/` before
any approved integration step.

#### Scenario: Draft output is emitted outside the live skill directory

- **WHEN** a trace is codified into a draft skill
- **THEN** the draft file lands under `scratchpad/skills-drafts/`
- **AND** the live skill directory remains unchanged until approval and
  integration succeed
