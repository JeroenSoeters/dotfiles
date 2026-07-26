# dotfiles

Personal dotfiles for an **Arch + [Omarchy](https://omarchy.org)** (Hyprland/Wayland, bash) setup.
Originally forked from [jessfraz/dotfiles](https://github.com/jessfraz/dotfiles), since trimmed
down to only the pieces actually in use.

## What's here

| File | Purpose |
|------|---------|
| `.tmux.conf` | tmux config. `C-z` prefix, `\|`/`-` splits. Colors follow the OS theme via terminal palette names (no plugin/TPM). |
| `scripts/tmux-sessionizer` | fzf-based project/session switcher, bound to `Ctrl-f`. |
| `.bashrc` | Omarchy base (`source ~/.local/share/omarchy/default/bash/rc`) plus personal PATH additions and the `Ctrl-f` keybind. |
| `.gitconfig` | git aliases and settings (not currently symlinked; Omarchy manages `~/.config/git`). |
| `.aliases`, `.functions`, `.exports`, `.path` | Reference shell snippets (not wired in — kept to cherry-pick from). |
| `.gnupg/` | gpg / gpg-agent config. |
| `gitignore` | Global gitignore template. |

## Install

There's no Makefile — symlink only what you want:

```bash
ln -sfn "$PWD/.tmux.conf"              ~/.tmux.conf
ln -sfn "$PWD/.bashrc"                 ~/.bashrc
mkdir -p ~/.local/share/scripts
ln -sfn "$PWD/scripts/tmux-sessionizer" ~/.local/share/scripts/tmux-sessionizer
```

`~/.tmux.conf` takes precedence over Omarchy's `~/.config/tmux/tmux.conf`.
