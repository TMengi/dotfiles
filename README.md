# Bootstrapping my dev environment
- Clone this repo
- Run `bootstrap.sh` to install software
- Run `stow.sh` to distribute dotfiles

## Major things this does not install

### Neovim
Obtain from [nvim releases page](https://github.com/neovim/neovim/releases)

### Gitconfig
A sample `.gitconfig` is included for reference, but is not automatically
stowed so as not to overwrite system-specific configuration.

## Additional local configuration
This is a publicly available repo, so any configuration that may reveal
proprietary information about a particular system has to live in a separate
location. The intended location is `$HOME/.local_zshrc`, which will be
automatically sourced by the main `.zshrc` if it exists.

## Technologies

### Fundamentals
- Git
    - Used for installing many other tools
    - See note about [[README#Gitconfig]]
    - Also includes [lazygit](https://github.com/jesseduffield/lazygit) and
      [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
        - Configuration in `.config/lazygit`
- GNU `stow`
- C/C++ build chain (gcc & g++)
- Rust toolchain (rustup)

### Shell: zsh
- Installed with apt
- Configuration in `.zshrc`
    - See also [[README#Additional local configuration]]

### Terminal emulator: alacritty
- [Github](https://github.com/alacritty/alacritty)
- Installed with cargo
- Includes desktop launcher
- Configuration in `.config/alacritty`

### Terminal multiplexer: zellij
- [zellij.dev](https://zellij.dev/)
- Installed with cargo
- Configuration in `.config/zellij`

### Editor: neovim
- **Not automatically installed**
- Configuration in `.config/nvim`
- TODO: Detailed configuration info

### Modern replacements for standard Unix tools
- `cd` -> [zoxide](https://github.com/ajeetdsouza/zoxide)
- `ls` -> [eza](https://eza.rocks/)
- `grep` -> [ripgrep](https://github.com/BurntSushi/ripgrep)
- `find` -> [fdfind](https://github.com/sharkdp/fd)
