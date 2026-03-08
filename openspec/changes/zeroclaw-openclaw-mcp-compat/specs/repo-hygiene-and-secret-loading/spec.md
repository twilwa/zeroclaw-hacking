## ADDED Requirements

### Requirement: Repo submodule metadata SHALL match tracked gitlinks
The repository SHALL keep `.gitmodules` aligned with the tracked submodule
gitlinks in the index so standard git submodule commands succeed without manual
repair.

#### Scenario: Invalid orphan mapping is removed
- **WHEN** the repo contains a tracked submodule mapping that is not present in
  the gitlink set
- **THEN** the mapping is removed from `.gitmodules`
- **THEN** `git submodule status` succeeds for the tracked submodule set

### Requirement: Tracked config SHALL not require plaintext runtime secrets
Tracked repository files SHALL not contain plaintext runtime secrets needed for
zeroclaw trace and deployment workflows.

#### Scenario: W&B access comes from runtime env
- **WHEN** a trace or deployment workflow needs W&B authentication
- **THEN** the workflow reads `WANDB_API_KEY` from runtime environment
  configuration
- **THEN** the tracked repo material does not embed the secret value

### Requirement: Phone deployment docs SHALL define env passthrough
Deployment material for phone-hosted zeroclaw SHALL document the use of
`autonomy.shell_env_passthrough` to expose approved env vars to shell and
process tools.

#### Scenario: Deployment config includes WANDB passthrough
- **WHEN** operators follow the deployment guidance for trace-aware skills
- **THEN** the documented configuration includes
  `autonomy.shell_env_passthrough = ["WANDB_API_KEY"]`
- **THEN** shell env access remains explicit and allowlisted
