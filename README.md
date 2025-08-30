# 🚀 NvSingh - Advanced Neovim Configuration

<div align="center">

```
███╗   ███╗██╗  ██╗███████╗██╗███╗   ██╗ ██████╗ ██╗  ██╗
████╗ ████║██║ ██╔╝██╔════╝██║████╗  ██║██╔════╝ ██║  ██║
██╔████╔██║█████╔╝ ███████╗██║██╔██╗ ██║██║  ███╗███████║
██║╚██╔╝██║██╔═██╗ ╚════██║██║██║╚██╗██║██║   ██║██╔══██║
██║ ╚═╝ ██║██║  ██╗███████║██║██║ ╚████║╚██████╔╝██║  ██║
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
                      @MKSingh_Dev
```

**A professional, feature-rich Neovim configuration built on LazyVim**

[![LazyVim](https://img.shields.io/badge/LazyVim-v8-blue.svg)](https://github.com/LazyVim/LazyVim)
[![Neovim](https://img.shields.io/badge/Neovim-v0.9+-green.svg)](https://neovim.io/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

## ✨ Features

- 🔥 **Advanced Development Environment** - Full-featured IDE experience with LSP, DAP, and more
- 🎨 **Beautiful UI** - Multiple color schemes with custom dashboard
- 🚀 **AI-Powered Coding** - Supermaven integration for intelligent code completion
- 🔧 **Multi-Language Support** - Pre-configured for JavaScript/TypeScript, Rust, Java, Go, Docker, and more
- 🐛 **Advanced Debugging** - Comprehensive DAP setup for multiple languages
- ⚡ **Optimized Performance** - Lazy loading and optimized startup times
- 🛠️ **Developer Tools** - Git integration, terminal, file management, and productivity plugins

## 📦 What's Included

### Language Support
- **JavaScript/TypeScript** - Complete setup with ESLint, Prettier, and debugging
- **Rust** - Rustaceanvim integration with LSP and debugging
- **Java** - Full JDTLS setup with Lombok support and debugging
- **Go** - Go language server and tooling
- **Docker** - Dockerfile syntax and LSP
- **Markdown** - Enhanced markdown editing
- **TOML/YAML/JSON** - Configuration file support
- **Tailwind CSS** - Utility-first CSS framework support

### Development Tools
- **LSP Configuration** - Language servers for intelligent code completion
- **DAP (Debug Adapter Protocol)** - Full debugging support for multiple languages
- **Git Integration** - Gitsigns, unified diff view, and more
- **Terminal Integration** - Built-in terminal with toggle functionality
- **File Management** - Advanced file explorer and search
- **AI Assistance** - Supermaven for intelligent code suggestions

### UI Enhancements
- **Custom Dashboard** - Personalized Alpha dashboard with MKSingh branding
- **Multiple Themes** - Catppuccin, Tokyo Night, GitHub, Kanso, and Yorumi themes
- **Status Line** - Rich status line with file information
- **Floating Diagnostics** - Enhanced error and warning display
- **Smooth Animations** - Smear cursor and other visual enhancements

## 🚀 Quick Start

### Prerequisites
- **Neovim** >= 0.9.0
- **Git**
- **Node.js** (for LSP servers)
- **Java 21** (for Java development)
- **Rust** (for Rust development)
- **Go** (for Go development)

### Installation

1. **Backup your existing Neovim configuration** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/MKSinghDev/NvSingh.git ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```
   
   LazyVim will automatically install all plugins on first launch.

### Post-Installation Setup

#### For Java Development
- Install Java 21 and update the path in `lua/plugins/java.lua` if needed
- Lombok is automatically configured for annotation processing

#### For JavaScript/TypeScript Development
- Install Node.js and npm
- ESLint and Prettier are pre-configured for automatic formatting

#### For Rust Development
- Install Rust toolchain: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Rustaceanvim provides advanced Rust tooling

## ⌨️ Key Mappings

### General
- `jj` - Exit insert mode (custom mapping)
- `<leader>gu` - Toggle git inline diff
- `<leader>i` - Show LSP hover diagnostics

### Debugging (DAP)
- `<leader>db` - Toggle breakpoint
- `<leader>dx` - Clear all breakpoints
- `<leader>dc` - Continue/Start debugging
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dl` - Step into
- `<leader>dj` - Step over (alternative)
- `<leader>dk` - Step out (alternative)
- `<leader>de` - Terminate debugging session
- `<leader>dr` - Run last debug configuration
- `<leader>dd` - Set conditional breakpoint
- `<leader>dt` - Debug Rust testables

### Search
- `z/` - Search forward within visual selection
- `z?` - Search backward within visual selection

*For complete LazyVim keymaps, see the [LazyVim documentation](https://lazyvim.github.io/keymaps)*

## 🎨 Themes

This configuration includes multiple beautiful themes:

- **Tokyo Night** (default) - Dark theme with vibrant colors
- **Catppuccin** - Soothing pastel theme
- **GitHub Dark** - GitHub's official dark theme
- **Kanso Zen** - Minimalist theme
- **Yorumi** - Elegant dark theme

To change themes, edit `lua/plugins/colorscheme.lua` and uncomment your preferred colorscheme.

## 🔧 Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Custom key mappings
│   │   ├── lazy.lua        # Lazy.nvim configuration
│   │   └── options.lua     # Neovim options
│   └── plugins/
│       ├── alpha.lua       # Custom dashboard
│       ├── colorscheme.lua # Theme configuration
│       ├── dap.lua         # Debug adapter setup
│       ├── java.lua        # Java development setup
│       ├── lspconfig.lua   # LSP server configuration
│       ├── rust.lua        # Rust development setup
│       ├── supermaven.lua  # AI code completion
│       └── ...             # Other plugin configurations
├── stylua.toml             # Lua formatter configuration
├── lazyvim.json            # LazyVim extras configuration
└── README.md               # This file
```

## 🛠️ Customization

### Adding New Plugins
Create a new file in `lua/plugins/` with your plugin configuration:

```lua
return {
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end,
}
```

### Modifying Keymaps
Edit `lua/config/keymaps.lua` to add or modify key mappings:

```lua
vim.keymap.set("n", "<leader>example", ":ExampleCommand<CR>", { desc = "Example command" })
```

### Changing Options
Modify `lua/config/options.lua` for Neovim settings:

```lua
vim.opt.relativenumber = true
vim.opt.wrap = false
```

## 🐛 Debugging Setup

This configuration includes comprehensive debugging support:

### Supported Languages
- **JavaScript/TypeScript** - Node.js and browser debugging
- **Java** - Full JDTLS integration
- **Rust** - Native Rust debugging
- **.NET Core** - C# debugging support

### Launch Configurations
The DAP setup automatically loads `.vscode/launch.json` files for project-specific debugging configurations.

## 📚 AI-Powered Development

### Supermaven Integration
- **Tab** - Accept suggestion
- **Ctrl+]** - Clear suggestion
- **Ctrl+J** - Accept word

Supermaven provides intelligent code completion powered by AI, making development faster and more efficient.

## 🔍 Language Server Features

- **Auto-completion** - Intelligent code completion
- **Go to definition** - Navigate to symbol definitions
- **Find references** - Find all symbol references
- **Hover information** - Documentation on hover
- **Diagnostics** - Real-time error checking
- **Code formatting** - Automatic code formatting
- **Refactoring** - Code refactoring tools

## 📖 LazyVim Extras

This configuration includes the following LazyVim extras:
- Biome formatting
- Docker language support
- Go language support
- Java language support
- JSON language support
- Markdown language support
- Rust language support
- Tailwind CSS support
- TOML language support
- TypeScript language support
- YAML language support
- Alpha dashboard UI
- Edgy window management
- Smear cursor animation

## 🤝 Contributing

Feel free to fork this repository and submit pull requests for improvements. Please ensure your changes are well-documented and tested.

## 📄 License

This configuration is open source and available under the [MIT License](https://opensource.org/licenses/MIT).

## 🙏 Acknowledgments

- [LazyVim](https://github.com/LazyVim/LazyVim) - The foundation of this configuration
- [Neovim](https://neovim.io/) - The amazing editor that makes this all possible
- All the plugin authors who create these incredible tools

## 📧 Contact

- GitHub: [@MKSinghDev](https://github.com/MKSinghDev)
- Twitter: [@MKSingh_Dev](https://twitter.com/MKSingh_Dev)

---

**Happy Coding! 🚀**
