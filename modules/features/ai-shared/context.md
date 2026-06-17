## Commands
If a just or make file is present, then read the commands and their descriptions before guessing at which commands to run for tasks like linting, testing, or building. Do not assume which commands are used without checking for existing definitions.

Always run the command directly instead of through make/just, but derive it from the make/just file if it exists.

## Development

When debugging issues, confirm the correct target (host, service, file) with the user before starting investigation. Do not assume which component is affected.

Always update and run tests and documentation after making a change.

If the tests are failing due to missing infrastructure, then explore the infrastructure setup (docker compose files, connection strings, etc) before exploring code changes. If the infrastructure is not started, then start it and rerun tests before exploring code changes.

## Go Development

Always run `golangci-lint run ./...` after making Go code changes and fix any issues before presenting work as complete. Do not dismiss or skip linter output.

Always run the relevant test suite (`go test ./...` or specific package tests) after making changes. Do not explore code extensively without running tests first when debugging test failures.

## Nix development

Always run `nix flake metadata` and `nix eval` to understand the structure of the flake and available outputs before making changes.

Always build the package/flake being modified to confirm it builds successfully after changes. Do not assume changes are correct without building.

Always run the formatter on Nix files to ensure consistent formatting. Do not make manual formatting changes.

## Infrastructure / Docker

When working with Docker/Azurite/external services, read existing config files (docker config.json, connection strings) before guessing at values like auth keys or API versions.

## Git

Never commit anything unless explicitly asked to. Never change PR descriptions, titles, comments or similar. Never reply to comments without explicit instruction. Also, never push unless explicitly asked to.
