# Claude Code Plugins

Personal marketplace for Claude Code plugins.

## Setup

Add this directory as a marketplace:

```bash
claude plugin marketplace add /Users/jamesbest/dotfiles/ai-stuff/claude/plugins
```

## Installing Plugins

Once the marketplace is added, install any plugin by name:

```bash
claude plugin install feature-dev
```

## Available Plugins

| Plugin | Description |
|--------|-------------|
| `feature-dev` | Comprehensive feature development workflow with specialized agents for codebase exploration, architecture design, and quality review |

## Adding New Plugins

1. Create a new directory under `plugins/`:

```
plugins/
├── .claude-plugin/
│   └── marketplace.json
├── feature-dev/
└── my-new-plugin/        <-- new plugin
    ├── .claude-plugin/
    │   └── plugin.json
    ├── agents/
    └── commands/
```

2. Create `.claude-plugin/plugin.json` in your plugin directory:

```json
{
  "name": "my-new-plugin",
  "description": "What the plugin does",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  }
}
```

3. Add the plugin to `.claude-plugin/marketplace.json`:

```json
{
  "name": "my-new-plugin",
  "source": "./my-new-plugin",
  "description": "What the plugin does",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  }
}
```

4. Validate and install:

```bash
claude plugin validate /Users/jamesbest/dotfiles/ai-stuff/claude/plugins
claude plugin marketplace update jibba-plugins
claude plugin install my-new-plugin
```

## Plugin Structure

A typical plugin contains:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json       # Plugin manifest (required)
├── agents/               # Agent definitions (.md files)
├── commands/             # Slash commands (.md files)
└── README.md             # Plugin documentation
```

## Useful Commands

```bash
# List installed plugins
claude plugin list

# Update marketplace index
claude plugin marketplace update jibba-plugins

# Validate a plugin
claude plugin validate ./my-plugin

# Uninstall a plugin
claude plugin uninstall my-plugin

# List configured marketplaces
claude plugin marketplace list
```
