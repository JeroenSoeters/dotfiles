# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for an **Arch + [Omarchy](https://omarchy.org)** setup (Hyprland/Wayland, bash).
Forked from [jessfraz/dotfiles](https://github.com/jessfraz/dotfiles) and trimmed to only what's in use.
There is no build, no test suite, and no package manager — changes are validated by sourcing the file
or reloading the relevant program (e.g. `tmux source-file ~/.config/tmux/tmux.conf`, `source ~/.bashrc`).

## Install / how files reach `$HOME`

There is **no Makefile or bootstrap script** — files are symlinked manually, one at a time (see README).
Consequences to keep in mind when editing:

- Editing a file here only takes effect if it's actually symlinked into `$HOME`. `.tmux.conf`, `.bashrc`,
  and `scripts/tmux-sessionizer` are the wired-in ones.
- `.tmux.conf` is symlinked to **`~/.config/tmux/tmux.conf`** (not `~/.tmux.conf`) — see the tmux section
  for why. Don't create a `~/.tmux.conf` symlink too; this file sources Omarchy's default itself.
- `.aliases`, `.functions`, `.exports`, `.path` are **sourced by `.bashrc`** only if the corresponding
  `~/.path` etc. symlinks exist — they are reference snippets to cherry-pick from, not guaranteed live.
- `.gitconfig` is **not** symlinked; Omarchy manages `~/.config/git`. Don't assume changes here affect git.
- `gitignore` (no dot) is the global-gitignore template; `.gitignore` is this repo's own ignore file.

## Architecture: the shell-config layering

The key structural fact is that this config **layers on top of Omarchy rather than replacing it**:

- `.bashrc` first `source`s `~/.local/share/omarchy/default/bash/rc` (all default Omarchy aliases/functions),
  then applies personal additions. Never redefine Omarchy defaults upstream — override them *after* that source line.
- Personal shell config is split across four files, sourced in order by `.bashrc`: `.path` (PATH mutations),
  `.exports` (env vars), `.aliases`, `.functions`.
- `.path` prepends `/opt/pel/bin` (formae), `~/.local/share/scripts`, `~/.local/bin`, Go, Rust, and gcloud SDK dirs.
- `.bashrc` binds `Ctrl-f` to `tmux-sessionizer`.

## tmux — layered on Omarchy (this is the subtle part)

tmux sources config in a fixed order and **the last file wins on conflicts**:
`/etc/tmux.conf` → `~/.tmux.conf` → `~/.config/tmux/tmux.conf`. Omarchy ships a *full*
`~/.config/tmux/tmux.conf` (prefix `C-Space`, its own splits/nav, theme). So a plain
`~/.tmux.conf` gets silently clobbered by Omarchy's file, which loads after it — this
is a real trap that already bit once (a `C-z` prefix reverted to `C-Space`).

The fix, mirroring how `.bashrc` layers on Omarchy:

- `.tmux.conf` is symlinked into the **winning slot**, `~/.config/tmux/tmux.conf`. There is
  intentionally **no `~/.tmux.conf`** (it would load first and be redundant).
- The file's first line `source-file ~/.local/share/omarchy/config/tmux/tmux.conf` pulls in
  Omarchy's *pristine* default (M-Enter splits, vi copy-mode, `Alt-1..9` window nav, and the
  OS-theme-following status bar). Everything after it is personal overrides that win because
  they run last: `C-z` prefix (clearing Omarchy's `C-Space`/`prefix2`), `|`/`-` splits,
  bottom status bar.
- **The Omarchy theme (sourced, not redefined here) uses terminal palette *names*** (`blue`,
  `black`, `brightblack`) so it re-themes with the OS theme. Don't hardcode hex if you add
  theme overrides.
- Two ways Omarchy can revert this, both recoverable by re-running the `ln -sfn` from the README:
  - `omarchy-refresh-tmux` overwrites `~/.config/tmux/tmux.conf` with Omarchy's default (destroying the
    symlink). It's **manual only** — the Omarchy menu → *Tmux* entry; nothing calls it automatically, and
    theme switching never touches tmux.
  - `omarchy update` migrations `sed -i` **directly into** `~/.config/tmux/tmux.conf`. `sed -i` replaces the
    symlink with a regular file, severing the link. Worse, because this file *sources* Omarchy's config
    instead of inlining it, a migration's `grep -q` marker guard won't find the marker and will try to
    re-apply — so future tmux migrations are the likely trigger. Your `~/dotfiles/.tmux.conf` is not edited
    (sed writes a detached copy), so re-linking fully restores it.
  - Symptom of either: prefix reverts to `C-Space`, or `ls -la ~/.config/tmux/tmux.conf` shows a regular
    file instead of a symlink.
- After editing, reload with `tmux source-file ~/.config/tmux/tmux.conf`; verify with
  `tmux show-options -g prefix` (expect `C-z`).

## tmux-sessionizer

`scripts/tmux-sessionizer` is an fzf-based project/session switcher. It `find`s one level deep under a
**hardcoded list of directories** (`~/dev/oss`, `~/dev/pel`, `~/dev/pel/formae/.worktrees`, `~/.config`,
`~/.local/share/scripts`, etc.), creates or attaches a detached tmux session named after the dir
(dots→underscores), and switches to it. To add a searched location, edit the `find` list on line 6.

## Conventions

- Target platform is Linux/Wayland only. Aliases assume Wayland tools (`wl-copy`/`wl-paste` for `pbcopy`/`pbpaste`).
- `.exports` sets `EDITOR=nvim` and points `FZF_DEFAULT_COMMAND` at ripgrep.
