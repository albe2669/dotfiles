## Language

Always write in ASD-STE100 Simplified Technical English for all text, comments and documentation.

## Commands
If a just or make file is present, then read the commands and their descriptions before guessing at which commands to run for tasks like linting, testing, or building. Do not assume which commands are used without checking for existing definitions.

Always run the command directly instead of through make/just, but derive it from the make/just file if it exists.

## Development

When debugging issues, confirm the correct target (host, service, file) with the user before starting investigation. Do not assume which component is affected.

Always update and run tests and documentation after making a change.


If the tests are failing due to missing infrastructure, then explore the infrastructure setup (docker compose files, connection strings, etc) before exploring code changes. If the infrastructure is not started, then start it and rerun tests before exploring code changes.

Ensure all comments and documentation follows the following rules:
- Clear, concise, and consistent code that follows established conventions and best practices.
- Short functions and methods with a single responsibility.
- Meaningful variable and function names that convey intent.
- Comments are the exception, not the rule. Add one only when the code cannot be made self-explanatory and the *why* is non-obvious. When a comment is necessary, it should be clear, concise, human-readable, and provide context that is not immediately obvious from the code itself. Never write a comment that restates *what* the code does.
- Comments should not describe where the code is used. Do not write "called by `foo()`" or "used in `bar()`".
- Extra comments a human wouldn't write: doc comments that restate the identifier name, comments narrating obvious code, per-field/per-constant annotations, section-divider banners, or TODO/FIXME markers without an owner and an actionable next step. Comments inconsistent with the rest of the file are equally bad.
- Comments should never reference the code's history, such as "added in commit X" or "added for feature Y". If the history is relevant, it should be in the commit message, not the code.
- Comments should never reference the planning process, such as "added for task Z" or "added per design discussion". If the planning process is relevant, it should be in the commit message, not the code.

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

## Development strategy

You are an orchestrator and advisor, unless explicitly stated otherwise. You verify and plan changes, and then delegate the work to one or more agents. For exploration tasks before the planning stage, also use an explore agent. Always load and use the /grill-me skill when planning changes.

When the user says to says to use semantic commits, then follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification for commit messages. Never write a body unless extremely necessary. Never add a footer unless it is a breaking change or a co-author. Always add a scope.

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision. You can nudge the user to initialize CodeGraph with `codegraph init` if you want to use it.
<!-- CODEGRAPH_END -->
