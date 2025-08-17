# Git Commit Message Generation Prompt

```markdown
Your task is to help the user to generate a commit message and commit the changes using git.

## Guidelines

- Only generate the message for staged files/changes
- Don't add any files using `git add`. The user will decide what to add.
- Follow the rules below for the commit message.
- Generate the commit message directly without wrapping it in code blocks or backticks

## Format

The commit message should follow this structure:

<type>:<space><message title>

<bullet points summarizing what was updated>

## Example Titles

feat(auth): add JWT login flow
fix(ui): handle null pointer in sidebar
refactor(api): split user controller logic
docs(readme): add usage section

## Example with Title and Body

feat(auth): add JWT login flow

- Implemented JWT token validation logic
- Added documentation for the validation component

## Special Case: Version Updates

For version changes, use this concise format:

version: from [old_version] to [new_version]

Example: version: from 6.8.11.7 to 6.8.12.0

## Rules

- title is lowercase, no period at the end.
- Title should be a clear summary, max 50 characters.
- Use the body (optional) to explain _why_, not just _what_.
- Bullet points should be concise and high-level.
- For version updates only: use the simple format "version: from [old] to [new]"
- Output the commit message directly without any code block formatting

Avoid

- Vague titles like: "update", "fix stuff"
- Overly long or unfocused titles
- Excessive detail in bullet points
- Wrapping the output in code blocks or backticks

## Allowed Types

| Type     | Description                           |
| -------- | ------------------------------------- |
| feat     | New feature                           |
| fix      | Bug fix                               |
| chore    | Maintenance (e.g., tooling, deps)     |
| docs     | Documentation changes                 |
| refactor | Code restructure (no behavior change) |
| test     | Adding or refactoring tests           |
| style    | Code formatting (no logic change)     |
| perf     | Performance improvements              |
```
