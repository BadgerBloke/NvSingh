# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Architecture Overview

This is a LazyVim-based Neovim configuration that extends the LazyVim starter template with custom plugins and configurations. The architecture follows a modular approach:

### Core Structure
- `init.lua` - Entry point that loads the lazy.nvim plugin manager
- `lua/config/` - Core configuration files (options, keymaps, autocmds, lazy setup)
- `lua/plugins/` - Individual plugin configurations that override or extend LazyVim defaults
- `lazyvim.json` - LazyVim extras configuration defining which language packs and features are enabled

### Plugin Management
- Uses lazy.nvim for plugin management with lazy loading
- LazyVim provides the base configuration and plugin ecosystem
- Custom plugins in `lua/plugins/` override or extend LazyVim defaults
- Plugin configurations are automatically loaded by file name matching

### Language Support Architecture
The configuration supports multiple languages through LazyVim extras:
- **Web Development**: TypeScript, JavaScript, React, Vue, Tailwind, Docker
- **Systems Programming**: Rust (rustaceanvim), Go, C#/.NET
- **JVM Languages**: Java (nvim-jdtls with Lombok support), Kotlin
- **Data**: Python, SQL, JSON, YAML, TOML
- **Other**: Elixir, Git, Markdown

### Development Tooling
- **LSP**: Multi-language server support with nvim-lspconfig
- **Debugging**: nvim-dap with language-specific adapters (Node.js, .NET Core, Rust via CodeLLDB)
- **AI**: Supermaven integration for code completion
- **Navigation**: Harpoon for file navigation
- **Formatting**: Prettier, Black, StyLua with format-on-save

## Common Commands

### LazyVim Management
```bash
# Open Neovim
nvim

# Within Neovim - Lazy plugin manager
:Lazy

# Update all plugins
:Lazy update

# Check plugin health
:checkhealth

# LazyVim changelog and updates
:LazyVim
```

### Configuration Management
```bash
# Format Lua configuration files
stylua lua/

# Check Lua syntax
luacheck lua/

# Reload configuration (within Neovim)
:source ~/.config/nvim/init.lua
```

### Language-Specific Development

#### Java Development
- Lombok support configured with automatic agent detection
- JDTLS workspace isolation by project
- Cross-platform support (Windows/macOS/Linux paths)

#### Rust Development
- Complete rustaceanvim setup (replaces LazyVim's rust extra)
- CodeLLDB debugger integration with Mason
- Crates.nvim for Cargo.toml dependency management
- Comprehensive rust-analyzer configuration with clippy integration
- Inlay hints support for better code visualization
- Auto-configured debug adapter based on platform

#### JavaScript/TypeScript
- ESLint integration with auto-fix on save
- Deno and Node.js LSP conflict resolution
- Chrome/Edge debugging support via DAP

#### .NET Core
- Cross-platform debugger support
- Automatic project building integration
- DLL path management for debugging

### Debugging Commands (nvim-dap)
```bash
# Key mappings within Neovim:
# <Leader>db - Toggle breakpoint
# <Leader>dx - Clear all breakpoints  
# <Leader>dc - Continue/Start debugging
# <Leader>do - Step over
# <Leader>dO - Step out
# <Leader>dl - Step into
# <Leader>de - Terminate debugger
# <Leader>dr - Run last configuration

# For Rust specifically:
# <Leader>dt - Debug Rust testables
```

### Custom Keybindings
- `jj` in insert mode maps to Escape
- `<Leader>a` - Add file to Harpoon
- `<C-e>` - Toggle Harpoon menu
- `<C-t>`, `<C-s>`, `<C-b>`, `<C-g>` - Navigate to Harpoon files 1-4
- `<Leader>i` - Open LSP hover diagnostics

## Configuration Customization

### Adding New Languages
1. Add the corresponding LazyVim extra to `lazyvim.json`
2. Create a plugin configuration file in `lua/plugins/` if custom setup is needed
3. Restart Neovim for changes to take effect

### Plugin Configuration
- Plugin configs in `lua/plugins/` automatically override LazyVim defaults
- Use the same plugin name as the LazyVim specification
- Configuration follows lazy.nvim plugin specification format

### Key Customizations
- ESLint auto-formatting is enabled by default
- Prettier requires a config file to be present
- Window titlebar shows file path via `winbar` option
- 4-space indentation is set as default (overriding LazyVim's 2-space default)

## Important Files
- `lazy-lock.json` - Locked plugin versions (should be committed)
- `stylua.toml` - Lua code formatting configuration  
- `.neoconf.json` - Neodev and lua_ls LSP configuration
- `lazyvim.json` - LazyVim extras and version tracking

## Development Workflow
1. This configuration auto-installs missing plugins on first run
2. Plugin updates are checked automatically (configurable in `lua/config/lazy.lua`)
3. LSP servers are managed by Mason (LazyVim handles installation)
4. Debugging configurations are automatically loaded from `.vscode/launch.json` if present
