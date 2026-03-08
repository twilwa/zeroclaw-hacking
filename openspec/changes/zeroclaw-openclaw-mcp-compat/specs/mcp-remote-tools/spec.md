## ADDED Requirements

### Requirement: Zeroclaw SHALL support streamable-HTTP MCP servers
Zeroclaw SHALL accept MCP server configuration through a new `[mcp]` section and
discover remote tools from enabled streamable-HTTP servers.

#### Scenario: Enabled server contributes tools
- **WHEN** `[mcp].enabled = true` and an enabled server is reachable
- **THEN** zeroclaw lists the server's tools during startup
- **THEN** zeroclaw registers each discovered tool in the shared tool registry

### Requirement: Remote MCP tools SHALL use namespaced identifiers
Zeroclaw SHALL expose remote MCP tools under `server.tool` names so local and
remote tools remain distinguishable and dispatch stays deterministic.

#### Scenario: Tool name includes server namespace
- **WHEN** zeroclaw registers a remote MCP tool named `list_runs` from server
  `wandb`
- **THEN** the registry exposes the tool as `wandb.list_runs`
- **THEN** later tool lookup uses the namespaced identifier

### Requirement: Remote server failures SHALL be non-fatal
Zeroclaw SHALL continue booting with local tools even when one or more MCP
servers fail discovery or invocation.

#### Scenario: One server fails and local tools still work
- **WHEN** one configured MCP server times out or returns an error during
  startup
- **THEN** zeroclaw logs the server failure
- **THEN** zeroclaw still starts with local tools and any healthy remote tools

### Requirement: Remote tool execution SHALL honor configured timeouts
Zeroclaw SHALL enforce connect and tool timeouts from the MCP server
configuration for remote tool calls.

#### Scenario: Slow server times out
- **WHEN** a remote MCP tool call exceeds the configured timeout
- **THEN** zeroclaw returns a tool error for that call
- **THEN** the failure does not disable unrelated tools or servers
