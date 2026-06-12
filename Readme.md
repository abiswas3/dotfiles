# Dotfiles

## Typst

Local Typst packages live under `~/.typst/`. To make the local
`random-walks` package available to imports like `@local/random-walks:0.4.1`,
symlink it into Typst's local package directory:

```zsh
mkdir -p ~/.local/share/typst/packages/local/random-walks
ln -sfn ~/dotfiles/.typst/typst-theorion \
  ~/.local/share/typst/packages/local/random-walks/0.4.1
```

Then compile papers from their entrypoint, for example:

```zsh
typst compile paper.typ
```

## macOS Fresh Install

Install Homebrew first, then run:

```zsh
brew bundle --file ~/dotfiles/Brewfile
cd ~/dotfiles
stow -t ~ .
nvim --headless '+Lazy! sync' '+TSInstallConfigured' '+qa'
```

`tree-sitter-cli` is required because this Neovim config uses the current
main-branch `nvim-treesitter` installer, which compiles parsers locally.

## Arch Fresh Install

```zsh
cd ~/dotfiles
bash install/arch.sh
```

The Arch package list lives in `packages/arch.txt`. The script uses
`pacman -S --needed`, so packages already present are left alone.

## After pulling changes

macOS:

```zsh
cd ~/dotfiles
brew bundle --file Brewfile
stow -t ~ .
nvim --headless '+Lazy! sync' '+TSInstallConfigured' '+qa'
```

Arch:

```zsh
cd ~/dotfiles
bash install/arch.sh
```

## Stow

To remove symlinks:

```zsh
stow -D . 
```

To specify the home directory as the stow target:

```zsh
stow -t ~ . 
```

From this repo, this also works because the default target is the parent directory:

```zsh
stow . 
```
