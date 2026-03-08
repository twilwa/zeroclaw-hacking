## ADDED Requirements

### Requirement: Zeroclaw shall configure remote MCP servers explicitly

`zeroclaw` SHALL expose an `[mcp]` config section with a global `enabled` flag
and `[[mcp.servers]]` entries containing `name`, `url`, optional `headers`,
`connect_timeout_secs`, `tool_timeout_secs`, and `enabled`.

#### Scenario: Disabled MCP config leaves runtime unchanged

- **WHEN** `[mcp] enabled = false`
- **THEN** `zeroclaw` does not attempt remote MCP registration

### Requirement: Zeroclaw shall support streamable-HTTP MCP servers in v1

`zeroclaw` SHALL register remote MCP tools only from streamable-HTTP servers in
this change.

#### Scenario: Remote HTTP tools become namespaced tools

- **WHEN** `zeroclaw` connects to a configured HTTP MCP server successfully
- **THEN** each remote tool is registered under the name `server.tool`

### Requirement: Remote MCP failures shall not block local tool startup

Remote MCP registration SHALL degrade gracefully when one or more configured
servers are unavailable.

#### Scenario: One remote server fails during boot

- **WHEN** at least one configured remote MCP server times out or errors during
  startup
- **THEN** `zeroclaw` still completes startup with its local tool set
- **AND** only the failed remote server is skipped

### Requirement: Remote tool execution shall honor per-server timeouts

`zeroclaw` SHALL apply configured connection and tool-call timeouts to remote
MCP interactions.

#### Scenario: Long-running remote tool call times out

- **WHEN** a remote MCP tool call exceeds `tool_timeout_secs`
- **THEN** `zeroclaw` returns a timeout failure for that tool call
