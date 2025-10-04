# Bootstrapping my dev environment
- Clone this repo
- Run `bootstrap.sh` to install software
- Run `stow.sh` to distribute dotfiles

## Major things this does not install

### Neovim
Obtain from [nvim releases page](https://github.com/neovim/neovim/releases)

### .gitconfig
This will be highly system specific, so is not automatically stowed. Though a
template version is included for reference.

## Additional local configuration
This is a publicly available repo, so any configuration that may reveal
proprietary information about a particular system has to live in a separate
location. The intended location is `$HOME/.local_zshrc`, which will be
automatically sourced by the main `.zshrc` if it exists.
