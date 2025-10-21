# Dotfiles Repository with Yadm

This repository contains my personal dotfiles managed with [Yadm](https://yadm.io/) (Yet Another Dotfiles Manager).

## Prerequisites

1. **Install Yadm** (if not already installed):
   ```bash
   # On macOS with Homebrew
   brew install yadm
   
   # On Debian/Ubuntu
   sudo apt install yadm
   
   # For other systems, see: https://yadm.io/docs/install
   ```

## Initial Setup (New Machine)

To set up these dotfiles on a new machine:

1. **Clone this repository with Yadm**:
   ```bash
   yadm clone https://github.com/alexandrekm/dotfiles.git
   ```
   
   The bootstrap script will run automatically and handle:
   - Package manager setup (Homebrew on macOS, apt on Debian/Ubuntu)
   - Essential package installation (Neovim, Git, curl, etc.)
   - Neovim plugin manager (vim-plug) installation
   - Automatic plugin installation
   - Shell configuration (Zsh/Bash) with useful defaults
   - Git configuration with sensible defaults

2. **Manual Bootstrap (if needed)**:
   ```bash
   ~/.config/yadm/bootstrap
   ```

## Managing Your Dotfiles with Yadm

### Basic Yadm Commands

Yadm works exactly like Git, but manages files in your `$HOME` directory:

```bash
# Check status of tracked files
yadm status

# Add new dotfiles to track
yadm add ~/.zshrc
yadm add ~/.gitconfig

# Commit changes
yadm commit -m "Add zsh and git configuration"

# Push changes to remote repository
yadm push

# Pull latest changes
yadm pull

# Show differences
yadm diff
```

### Adding New Configuration Files

To add new dotfiles to this repository:

1. **Add the file to Yadm tracking**:
   ```bash
   yadm add ~/.config/alacritty/alacritty.yml
   ```

2. **Commit the changes**:
   ```bash
   yadm commit -m "Add Alacritty configuration"
   ```

3. **Push to repository**:
   ```bash
   yadm push
   ```

### Updating Existing Files

When you modify a tracked dotfile:

1. **Check what changed**:
   ```bash
   yadm diff
   ```

2. **Add and commit the changes**:
   ```bash
   yadm add -u  # Add all modified tracked files
   yadm commit -m "Update Neovim configuration"
   ```

3. **Push to repository**:
   ```bash
   yadm push
   ```

## Neovim Configuration Details

The `.nvimrc` file includes:

- **Basic settings**: Line numbers, smart indentation, clipboard integration
- **Plugin management**: Using vim-plug
- **NERDCommenter**: Enhanced commenting with `<Leader>cc` to comment and `<Leader>cu` to uncomment
- **EasyMotion**: Quick navigation with `<Leader><Leader>w` to jump to words

### Installing Neovim Plugins

After setting up the dotfiles, install the plugins:

```bash
# Open Neovim and run the plugin install command
nvim +PlugInstall +qall
```

## Bootstrap System

This repository includes a modular bootstrap system that automatically sets up your development environment on both Linux and macOS.

### Bootstrap Structure

```
.config/yadm/
├── bootstrap              # Main bootstrap script (symlink)
├── bootstrap_scripts/     # Modular bootstrap components
│   ├── bootstrap         # Main orchestrator script
│   ├── packages/
│   │   └── setup         # Package manager and essential packages
│   ├── nvim/
│   │   └── setup         # Neovim and plugin configuration
│   ├── shell/
│   │   └── setup         # Shell (Zsh/Bash) and Git configuration
│   └── utils/
│       └── functions.sh  # Cross-platform utility functions
```

### Bootstrap Options

Run the full bootstrap:
```bash
~/.config/yadm/bootstrap
```

Run specific components:
```bash
~/.config/yadm/bootstrap --packages  # Only package setup
~/.config/yadm/bootstrap --nvim      # Only Neovim setup
~/.config/yadm/bootstrap --shell     # Only shell setup
~/.config/yadm/bootstrap --help      # Show all options
```

### What Each Component Does

#### **Packages Setup** (`packages/setup`)
- **macOS**: Installs Homebrew and essential packages
- **Debian/Ubuntu**: Updates package lists and installs packages via apt
- **Packages**: neovim, git, curl, wget, tree, jq, ripgrep, fd, build tools

#### **Neovim Setup** (`nvim/setup`)
- Installs vim-plug plugin manager
- Automatically installs plugins from `.nvimrc`
- Creates necessary Neovim directories
- Runs health checks

#### **Shell Setup** (`shell/setup`)
- Creates comprehensive `.zshrc` with useful defaults
- Creates `.bashrc` for Bash compatibility
- Sets up `.gitconfig` with sensible defaults
- Creates useful directories (`~/projects`, `~/.local/bin`, etc.)
- Platform-specific configurations

### Supported Platforms

#### **macOS**
- Homebrew package management
- Apple Silicon and Intel support
- Xcode Command Line Tools integration

#### **Linux Distributions**
- **Debian/Ubuntu**: apt package manager
- Automatic distribution detection

## Troubleshooting

### Permission Issues
If you encounter permission issues:
```bash
yadm decrypt  # If using encryption
yadm perms    # Fix file permissions
```

### Merge Conflicts
Handle merge conflicts like in Git:
```bash
yadm pull
# Resolve conflicts in affected files
yadm add <resolved-files>
yadm commit -m "Resolve merge conflicts"
yadm push
```

## Useful Yadm Features

### Machine-Specific Configurations

Yadm supports templates and alternate files for machine-specific configurations. See the [Yadm documentation](https://yadm.io/docs/alternates) for more details.

### Customization

- **Shell**: Create `~/.zshrc.local` for additional shell customization
- **Git**: The bootstrap creates a basic `.gitconfig` - remember to set your user info:
  ```bash
  git config --global user.name 'Your Name'
  git config --global user.email 'your.email@example.com'
  ```
- **Neovim**: Add more plugins to `.nvimrc` as needed

## Repository Structure

```
~/ (managed by yadm)
├── .nvimrc                           # Neovim configuration
└── .config/yadm/
    ├── bootstrap -> bootstrap_scripts/bootstrap
    └── bootstrap_scripts/            # Modular bootstrap system
        ├── bootstrap                 # Main orchestrator
        ├── packages/setup           # Package management
        ├── nvim/setup              # Neovim configuration
        ├── shell/setup             # Shell and Git setup
        └── utils/functions.sh      # Cross-platform utilities
```

## Resources

- [Yadm Documentation](https://yadm.io/docs/)
- [Vim-Plug Documentation](https://github.com/junegunn/vim-plug)
- [Neovim Documentation](https://neovim.io/doc/)

## Contributing

Feel free to fork this repository and adapt it to your needs. If you find improvements that could benefit others, pull requests are welcome!
