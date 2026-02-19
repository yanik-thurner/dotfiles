dotfiles
===

Set it up with:
```sh
git clone --bare <repo-url> $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
source .bashrc
```
