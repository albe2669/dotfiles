---
name: fix-lint
description: For fixing go code. Run golangci-lint, fix all issues, and confirm tests pass
---

# Fix Lint Errors
1. Run `golangci-lint run ./...` and capture output
2. Fix ALL reported issues across all files
3. Re-run linter to confirm zero issues
4. Run `go test ./...` to ensure fixes don't break tests
5. Only report done when both linter and tests pass clean
