#!/usr/bin/fish

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install \
    fisherman/fzf \
    fisherman/gitignore \
    fisherman/z \
    dcors/fish-ghq \
    edc/bass \
    jorgebucaran/nvm.fish \
    oh-my-fish/theme-bobthefish

nvm install lts
nvm use lts
