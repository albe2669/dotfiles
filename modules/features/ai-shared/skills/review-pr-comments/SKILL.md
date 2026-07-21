---
name: review-pr-comments
description: Review and address unresolved comments on the current branch's PR. Shows each comment with author and proposed solution, commits approved changes one by one, and only pushes on user authorization.
---

## Workflow

### Phase 1: Identify the PR

1. Get the current branch:

```bash
git branch --show-current
```

2. Find open PRs for this branch:

```bash
gh pr list --head $(git branch --show-current) --state open --json number,title,url
```

3. If no PR found, inform user and exit
4. If multiple PRs found, ask user which one to review

### Phase 2: Fetch Unresolved Comments

Use the GitHub GraphQL API. `gh pr view --json` does **not** expose
`reviewThreads` (it is not a valid JSON field), so query GraphQL directly
via `gh api graphql`. Use the PR URL captured in Phase 1 (`gh pr list ... --json url`):

```bash
gh api graphql -f query='
query($url: URI!) {
  resource(url: $url) {
    ... on PullRequest {
      reviewThreads(first: 100) {
        nodes {
          id
          path
          line
          isResolved
          isOutdated
          comments(first: 5) {
            nodes {
              author { login }
              body
              databaseId
            }
          }
        }
      }
    }
  }
}' -F url="$PR_URL" \
  --jq '.data.resource.reviewThreads.nodes[] | select(.isResolved == false) | {threadId: .id, path: .path, line: .line, isOutdated: .isOutdated, comments: [.comments.nodes[] | {author: .author.login, body: .body, commentId: .databaseId}]}'
```

For each thread, capture:
- `threadId` — the GraphQL node ID (needed to resolve the thread in Phase 5).
- the first comment's `commentId`.
- `isOutdated` — `true` means the referenced line has shifted since the comment was left; the thread can still be resolved.

If no unresolved comments, inform user and exit.

### Phase 3: Review Each Comment

For each unresolved comment, follow this sequence:

**1. Display comment immediately** (before any analysis):
```
Comment {N}/{TOTAL}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: {path}:{line}
Author: @{author}

"{comment body}"

Analyzing this comment...
```

**2. Analyze** (while user reads the comment):
- Read the file and relevant code context
- Evaluate if the comment raises a valid concern vs. stylistic preference
- Assess impact and necessity of any change
- Formulate response: code change, reason to ignore, or note for manual discussion

**3. Present solution** (using AskUserQuestion):
- Show your evaluation and proposed solution or reason to ignore
- Include specific code changes if applicable
- Options: "Apply suggested fix" | "Ignore comment" | "Skip for now" | "Stop reviewing"

**4. Execute if approved**:
- If "Apply suggested fix": Make the change and commit with descriptive message. **Record the mapping** of this comment (its `threadId` + `commentId`) to the commit SHA that addresses it.
- If "Ignore" or "Skip": Move to next comment (optionally note the reason for Phase 5).
- If "Stop reviewing": Exit workflow

### Phase 4: Summary and Push

After processing all comments:

Show summary:
- Total comments reviewed
- Comments addressed (with commit SHAs)
- Comments ignored/skipped

Do not push or reply to comments.


## Guidelines

### Critical Evaluation Criteria

**Address if:**

- Security vulnerability or bug
- Performance issue with measurable impact
- Breaking change or API contract violation
- Code correctness issue
- Accessibility or UX problem
- Violation of project conventions (if documented)

**Consider ignoring if:**

- Pure stylistic preference without documented standard
- Subjective opinion without clear rationale
- Already addressed in a different way
- Out of scope for current PR
- Minor suggestion that doesn't impact functionality

**Always be transparent**: Even when recommending to ignore, present it to the user with reasoning.

### Commit Message Format

Use conventional commits format describing the actual change:

```
{type}: {what was changed}
```

**Types**: `fix:`, `refactor:`, `test:`, `docs:`, `chore:`

**Examples**:
- ✅ `fix: ignore ErrTxClosed in rollback after commit`
- ✅ `refactor: use go run for mockgen to ensure reproducibility`
- ❌ `fix: address PR comment by @author` (too generic)
- ❌ `update` (missing type and description)

### Error Handling

- If `gh` CLI not available, inform user to install it
- If `gh pr view --json` fails on `reviewThreads`, that field is not supported — use the GraphQL query in Phase 2 instead
- If PR view fails, check if user has permissions
- If file read fails, note that file may have been moved/deleted
- If commit fails, show error and ask how to proceed

## Output Style

- Number comments (e.g., "Comment 1/5")
- Show file paths as `file:line` for easy navigation
- Show commit SHA after each commit
- After Phase 5, report how many threads were replied to and resolved, and confirm zero remain unresolved

## Examples

### Example 1: Valid Concern

**Initial display:**
```
Comment 2/5
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: pkg/parser/parse.go:45
Author: @johndoe

"This can panic if `parts` is empty — should we check the length before indexing `parts[0]`?"

Analyzing this comment...
```

**After analysis:**
```
My evaluation: Valid concern - potential panic on an empty slice.

Proposed fix: Add a length check and return early with an error before indexing.

[Options: Apply suggested fix | Ignore comment | Skip for now | Stop reviewing]
```

### Example 2: Stylistic Preference

**Initial display:**
```
Comment 3/5
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: pkg/server/handler.go:12
Author: @janedoe

"Consider using `const` instead of `var` here"

Analyzing this comment...
```

**After analysis:**
```
My evaluation: The value is reassigned later in the function, so `var` is correct.

Recommendation: Ignore this comment

[Options: Apply suggested fix | Ignore comment | Skip for now | Stop reviewing]
```
