## ADDED Requirements

### Requirement: Root submodule metadata shall match the intended OpenClaw set

The repository SHALL define root submodule metadata only for `AgenC`,
`bootstrap`, `ZeroClaw-Android`, `awesome-openclaw-skills`,
`awesome-openclaw-usecases`, `babyagi3`, `clawhub`, `moltworker`, `nanobot`,
`openclaw`, `sediment`, and `zeroclaw`.

#### Scenario: Invalid orphan mapping is removed

- **WHEN** the repository metadata is inspected after the change
- **THEN** there is no `submodule "--force"` entry in `.gitmodules`
- **AND** the orphan `--force` gitlink is not present in the index

### Requirement: Submodule operations shall succeed after the repair

The repository SHALL be left in a state where standard submodule inspection can
run without metadata errors.

#### Scenario: Git can enumerate submodules

- **WHEN** `git submodule status` is run from the repository root
- **THEN** Git reports the configured submodules without failing on unmapped
  paths

### Requirement: Tracked phoneclaw MCP config shall not contain plaintext W&B credentials

Tracked `phoneclaw-research` configuration SHALL not store a W&B API key value
directly in versioned files.

#### Scenario: Runtime env replaces tracked secret

- **WHEN** `phoneclaw-research/.mcp.json` is reviewed after the change
- **THEN** it references runtime environment loading instead of embedding the
  W&B key value

### Requirement: Phone deployment guidance shall use shell env passthrough

Phone deployment and launch guidance SHALL document `WANDB_API_KEY` delivery
through `autonomy.shell_env_passthrough`.

#### Scenario: Deployment docs mention passthrough explicitly

- **WHEN** a maintainer follows the updated phoneclaw deployment material
- **THEN** the instructions show `autonomy.shell_env_passthrough =
  ["WANDB_API_KEY"]`
- **AND** they do not instruct the maintainer to commit plaintext credentials
