dotfiles
===

Set it up with:
```sh
git clone --recurse-submodules --bare ssh://git@git.uwu.sh/jay/dotfiles.git "$HOME/.dotfiles"

git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config core.bare false
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config core.worktree "$HOME"
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config status.showUntrackedFiles no
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
source .bashrc
```
