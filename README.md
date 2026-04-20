# devantler-tech/copilot-plugins

A [copilot-plugin marketplace](https://code.visualstudio.com/docs/copilot/customization/agent-plugins) that bundles the curated agent skills from [`devantler-tech/skills`](https://github.com/devantler-tech/skills) into category-based plugins.

Supports **VS Code**, **GitHub Copilot CLI**, and **Claude Code** via dual marketplace manifests.

## Plugins

| Plugin | Skills | Description |
|--------|--------|-------------|
| [`gitops-kubernetes`](plugins/gitops-kubernetes/) | `gitops-cluster-debug`, `gitops-knowledge`, `gitops-repo-audit`, `siderolabs` | GitOps & Kubernetes debugging, auditing, and knowledge |
| [`github`](plugins/github/) | `gh-cli`, `gh-stack`, `github-actions-docs`, `github-issues` | GitHub CLI, stacked PRs, Actions docs, and issue management |
| [`copilot`](plugins/copilot/) | `copilot-instructions-blueprint-generator`, `copilot-sdk`, `find-skills` | Copilot customisation and skill discovery |
| [`go`](plugins/go/) | `bubbletea`, `golang-pro` | Go development with Bubble Tea TUIs and best practices |
| [`engineering-practices`](plugins/engineering-practices/) | `git-commit`, `refactor`, `test-driven-development` | Git commits, refactoring, and TDD |
| [`frontend-design`](plugins/frontend-design/) | `astro`, `frontend-design`, `web-design-guidelines` | Astro, frontend design, and web design guidelines |

## Installation

### VS Code

Add the marketplace to your settings:

```jsonc
// settings.json
"chat.plugins.marketplaces": [
    "devantler-tech/copilot-plugins"
]
```

Then browse **Extensions → Agent Plugins** (`@agentPlugins` search) to install individual plugins.

### Copilot CLI

```sh
# Browse available plugins
copilot plugin marketplace browse devantler-tech/copilot-plugins

# Install a plugin
copilot plugin install gitops-kubernetes@devantler-copilot-plugins
```

### Claude Code

The repo includes a `.claude-plugin/marketplace.json` for automatic discovery.

## How it works

Skills are **vendored** from their upstream repositories using the [`npx skills add`](https://agentskills.io) CLI. A [daily sync workflow](.github/workflows/sync-skills.yaml) re-vendors all skills and opens a PR when upstream content has drifted.

Each plugin directory is self-contained with a `plugin.json` manifest and a `skills/` subdirectory holding the vendored `SKILL.md` files (plus any supporting assets).

See [`devantler-tech/skills`](https://github.com/devantler-tech/skills) for the curated skill index and upstream links.

## Contributing

See the [devantler-tech organisation guidelines](https://github.com/devantler-tech/.github) for PR/issue templates and contribution rules.

## License

Apache 2.0 — see [`LICENSE`](LICENSE).
