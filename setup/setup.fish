#!/usr/bin/fish

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source \
    && fisher install jorgebucaran/fisher
fisher install \
    fisherman/fzf \
    fisherman/gitignore \
    fisherman/z \
    dcors/fish-ghq \
    edc/bass \
    oh-my-fish/theme-bobthefish
