# dotfiles

Personal dotfiles for an **Arch + [Omarchy](https://omarchy.org)** (Hyprland/Wayland, bash) setup.
Originally forked from [jessfraz/dotfiles](https://github.com/jessfraz/dotfiles), since trimmed
down to only the pieces actually in use.

## What's here

| File | Purpose |
|------|---------|
| `.tmux.conf` | tmux config, layered on Omarchy: sources Omarchy's default then overrides (`C-z` prefix, `\|`/`-` splits, bottom status bar). Symlinked into `~/.config/tmux/tmux.conf` so it wins the load order. |
| `scripts/tmux-sessionizer` | fzf-based project/session switcher, bound to `Ctrl-f`. |
| `.bashrc` | Omarchy base (`source ~/.local/share/omarchy/default/bash/rc`) plus personal PATH additions and the `Ctrl-f` keybind. |
| `.gitconfig` | git aliases and settings (not currently symlinked; Omarchy manages `~/.config/git`). |
| `.aliases`, `.functions`, `.exports`, `.path` | Reference shell snippets (not wired in — kept to cherry-pick from). |
| `.gnupg/` | gpg / gpg-agent config. |
| `gitignore` | Global gitignore template. |

## Install

There's no Makefile — symlink only what you want:

```bash
# tmux: take over the winning config slot (loads last). Do NOT also symlink
# ~/.tmux.conf — this file sources Omarchy's default itself.
ln -sfn "$PWD/.tmux.conf"              ~/.config/tmux/tmux.conf
ln -sfn "$PWD/.bashrc"                 ~/.bashrc
mkdir -p ~/.local/share/scripts
ln -sfn "$PWD/scripts/tmux-sessionizer" ~/.local/share/scripts/tmux-sessionizer
```

tmux loads `/etc/tmux.conf` → `~/.tmux.conf` → `~/.config/tmux/tmux.conf`, and the
**last file wins** on conflicts. Omarchy ships a full `~/.config/tmux/tmux.conf`, so
`.tmux.conf` must occupy that slot to stay authoritative; it sources Omarchy's
pristine default (`~/.local/share/omarchy/config/tmux/tmux.conf`) first, then overrides.
Running `omarchy-refresh-tmux` overwrites the symlink with Omarchy's default — re-run
the `ln` above to restore.
