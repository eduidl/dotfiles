#!/usr/bin/fish

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source \
    && fisher install jorgebucaran/fisher
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
