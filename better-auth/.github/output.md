/Users/josh/Documents/GitHub/better-auth/better-auth/.github/FUNDING.yml
```yaml
github: [better-auth]
```
/Users/josh/Documents/GitHub/better-auth/better-auth/.github/workflows/ci.yml
```yaml
name: CI

on: 
    pull_request:  
        types: 
          - opened
          - synchronize
    push:
      branches:
        - main
        - 'v**'
    merge_group: {}

jobs:
    test:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v4
              with:
                    fetch-depth: 0

            - name: Cache turbo build setup
              uses: actions/cache@v4
              with:
                path: .turbo
                key: ${{ runner.os }}-turbo-${{ github.sha }}
                restore-keys: |
                  ${{ runner.os }}-turbo-

            - uses: pnpm/action-setup@v4

            - uses: actions/setup-node@v4
              with:
                node-version: 20.x
                registry-url: 'https://registry.npmjs.org'
                cache: pnpm
            
            - name: Install
              run: pnpm install

            - name: Build
              env:
                TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
                TURBO_TEAM: ${{ vars.TURBO_TEAM || github.repository_owner }}
                TURBO_REMOTE_ONLY: true
              run: pnpm build
            
            - name: Start Docker Containers
              run: |
                docker compose up -d
                # Wait for services to be ready (optional)
                sleep 10
            
            - name: Lint
              env:
                TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
                TURBO_TEAM: ${{ vars.TURBO_TEAM || github.repository_owner }}
                TURBO_REMOTE_ONLY: true
              run: pnpm lint
            
            - name: Test
              env:
                TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
                TURBO_TEAM: ${{ vars.TURBO_TEAM || github.repository_owner }}
              run: pnpm test

            - name: Typecheck
              env:
                TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
                TURBO_TEAM: ${{ vars.TURBO_TEAM || github.repository_owner }}
                TURBO_REMOTE_ONLY: true
              run: pnpm typecheck

            - name: Stop Docker Containers
              run: docker compose down
            
```
/Users/josh/Documents/GitHub/better-auth/better-auth/.github/workflows/discord.yml
```yaml
name: Discord

on:
  release:
      types: [published]
 
jobs:
    github-releases-to-discord:
      runs-on: ubuntu-latest
      steps:
        - name: Checkout
          uses: actions/checkout@v3
        - name: Github Releases To Discord
          uses: SethCohen/github-releases-to-discord@v1.15.1
          with:
            webhook_url: ${{ secrets.WEBHOOK_URL }}
            color: "2105893"
            username: "Release Changelog"
            avatar_url: "https://cdn.discordapp.com/avatars/487431320314576937/bd64361e4ba6313d561d54e78c9e7171.png"
            content: "||@everyone||"
            footer_title: "Changelog"
            footer_icon_url: "https://cdn.discordapp.com/avatars/487431320314576937/bd64361e4ba6313d561d54e78c9e7171.png"
            footer_timestamp: true
            max_description: '4096'
            reduce_headings: true
```
/Users/josh/Documents/GitHub/better-auth/better-auth/.github/workflows/preview.yml
```yaml
name: Publish Any Commit
on: [pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Cache turbo build setup
        uses: actions/cache@v4
        with:
          path: .turbo
          key: ${{ runner.os }}-turbo-${{ github.sha }}
          restore-keys: |
            ${{ runner.os }}-turbo-

      - uses: pnpm/action-setup@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20.x
          registry-url: 'https://registry.npmjs.org'
          cache: pnpm
      
      - name: Install
        run: pnpm install

      - name: Build
        env:
          TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
          TURBO_TEAM: ${{ vars.TURBO_TEAM || github.repository_owner }}
          TURBO_REMOTE_ONLY: true
        run: pnpm build
          
      - run: pnpm dlx pkg-pr-new publish --pnpm ./packages/*
```
/Users/josh/Documents/GitHub/better-auth/better-auth/.github/workflows/release.yml
```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

permissions:
  contents: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: actions/setup-node@v4
        with:
          node-version: 20.x

      - run: npx changelogithub
        env:
          GITHUB_TOKEN: ${{secrets.GITHUB_TOKEN}}
          
      - uses: pnpm/action-setup@v4

      - uses: actions/setup-node@v4
        with:
            node-version: 20.x
            registry-url: 'https://registry.npmjs.org'

      - run: pnpm install
      
      - name: Build
        run: pnpm build

      - name: Determine npm tag
        id: determine_npm_tag
        shell: bash
        run: |
          TAG="${GITHUB_REF#refs/tags/}"
          if [[ "$TAG" =~ -(next|canary|beta|rc) ]]; then
            # Extract pre-release tag (e.g., beta, rc)
            NPM_TAG=${BASH_REMATCH[1]}
          else
            # Check if the commit is on the main branch
            git fetch origin main
            if git merge-base --is-ancestor "$GITHUB_SHA" origin/main; then
              NPM_TAG="latest"
            else
              echo "The tagged commit is not on the main branch."
              echo "::error ::Releases with the 'latest' npm tag must be on the main branch."
              exit 1
            fi
          fi
          echo "npm_tag=$NPM_TAG" >> $GITHUB_OUTPUT
          echo "Using npm tag: $NPM_TAG"

      - name: Publish to npm
        run: pnpm -r publish --access public --no-git-checks --tag ${{ steps.determine_npm_tag.outputs.npm_tag }}
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```
/Users/josh/Documents/GitHub/better-auth/better-auth/.github/ISSUE_TEMPLATE/bug_report.yml
```yaml
name: Report an issue
description: Create a report to help us improve
body:
  - type: checkboxes
    attributes:
      label: Is this suited for github?
      description: Feel free to join the discord community [here](https://discord.gg/better-auth), we can usually respond faster to any questions.
      options:
        - label: Yes, this is suited for github
  - type: markdown
    attributes:
      value: |
        This template is used for reporting a issue with better-auth.

        Feature requests should be opened in [here](https://github.com/better-auth/better-auth/issues/new?assignees=&labels=&projects=&template=feature_request.md&title=).

        Before opening a new issue, please do a [search](https://github.com/better-auth/better-auth/issues) of existing issues and :+1: upvote the existing issue instead. This will result in a quicker resolution.
  - type: textarea
    attributes:
      label: To Reproduce
      description: A step-by-step description of how to reproduce the issue, based on the linked reproduction. Screenshots can be provided in the issue body below. If using code blocks, make sure that [syntax highlighting is correct](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-and-highlighting-code-blocks#syntax-highlighting) and double check that the rendered preview is not broken.
      placeholder: |
        Ex:
        1. Create a backend
        2. Create a frontend and use client
        3. X will happen
    validations:
      required: true
  - type: textarea
    attributes:
      label: Current vs. Expected behavior
      description: |
        A clear and concise description of what the bug is (e.g., screenshots, logs, etc.), and what you expected to happen.

        **Skipping this/failure to provide complete information of the bug will result in the issue being closed.**
      placeholder: 'Following the steps from the previous section, I expected A to happen, but I observed B instead.'
    validations:
      required: true
  - type: input
    attributes:
      label: What version of Better Auth are you using?
      description: Please provide the current version of `better-auth` that you are reporting the bug on
      placeholder: "1.x.x"
    validations:
      required: true
  - type: textarea
    attributes:
      label: Provide environment information
      description: Please collect the following information and paste the results. 
      render: bash
      placeholder: |
        - OS: [e.g. Windows 10]
        - Browser [e.g. chrome, safari]
    validations:
      required: true
  - type: dropdown
    attributes:
      label: Which area(s) are affected? (Select all that apply)
      multiple: true
      options:
        - 'Backend'
        - 'Client'
        - 'Types'
        - 'Documentation'
        - 'Package'
        - 'Other'
    validations:
      required: true
  - type: textarea
    attributes:
      label: Auth config (if applicable)
      description: If you haven't already shared a reproducible example or don't think it's unrelated, please include your auth config. Make sure to remove any sensitive information.
      render: typescript
      value: |
        import { betterAuth } from "better-auth"
        export const auth = betterAuth({
          emailAndPassword: {  
            enabled: true
          },
        });
  - type: textarea
    attributes:
      label: Additional context
      description: |
        Any extra information that might help us investigate. For example, is it only reproducible online, or locally too? Is the issue only happening in a specific browser? etc.
      placeholder: |
        I tested my reproduction against the latest release.

```
/Users/josh/Documents/GitHub/better-auth/better-auth/.github/ISSUE_TEMPLATE/feature_request.yml
```yaml
name: Feature request
description: Suggest an idea for this project
body:
  - type: checkboxes
    attributes:
      label: Is this suited for github?
      description: Feel free to join the discord community [here](https://discord.gg/better-auth), we can usually respond faster to any questions.
      options:
        - label: Yes, this is suited for github
  - type: markdown
    attributes:
      value: |
        This template is used for suggesting a feature with better-auth.

        Bug reports should be opened in [here](https://github.com/better-auth/better-auth/issues/new?assignees=&labels=bug&projects=&template=bug_report.yml).

        Before opening a feature request, please do a [search](https://github.com/better-auth/better-auth/issues) of existing issues and :+1: upvote the existing request instead. This will result in a quicker resolution.
  - type: textarea
    attributes:
      label: Is your feature request related to a problem? Please describe.
      description: A clear and concise description of what the problem is. Ex. I'm always frustrated when [...]
  - type: textarea
    attributes:
      label: Describe the solution you'd like
      description: A clear and concise description of what you want to happen.
    validations:
      required: true
  - type: textarea
    attributes:
      label: Describe alternatives you've considered
      description: A clear and concise description of any alternative solutions or features you've considered.
    validations:
      required: true
  - type: textarea
    attributes:
      label: Additional context
      description: Add any other context or screenshots about the feature request here.

```
