#!/bin/bash

set -eo pipefail

env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

PATH=${PATH}:$HOME/.local/bin

# PPA
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:fish-shell/release-4
sudo add-apt-repository -y ppa:neovim-ppa/stable

sudo apt update
sudo apt install -y \
    build-essential \
    ca-certificates \
    ccache \
    curl \
    fd-find \
    fish \
    fzf \
    git \
    gnupg \
    golang-go \
    libssl-dev \
    lsb-release \
    neovim \
    ninja-build \
    python3-dev \
    python3-venv \
    ripgrep \
    vim \
    tig \
    wget

mkdir -p ~/.local/bin
ln -sf "$(which fdfind)" ~/.local/bin/fd

chsh -s /usr/bin/fish

# fontのインストール
git clone https://github.com/powerline/fonts.git --depth=1
pushd fonts
./install.sh
popd
rm -rf fonts

# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
sudo apt update
sudo apt install -y gh

# Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin
sudo gpasswd -a "${USER}" docker

# Python
sudo apt install -y
curl https://bootstrap.pypa.io/get-pip.py | python3
curl -LsSf https://astral.sh/uv/install.sh | sh
for lib in black clang-format cmake pipenv poetry isort; do
    uv tool install $lib
done

poetry config virtualenvs.in-project true

# Rust
# https://www.rust-lang.org/tools/install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup toolchain add beta
cargo install \
    cargo-update \
    du-dust \
    eza \
    git-delta

# Terminal
sudo apt install cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
cargo install \
    alacritty \
    zellij

# symlinks
mkdir -p ~/.config/fish/
ln -snf ~/dotfiles/fish/config.fish ~/.config/fish/config.fish

for d in alacritty git nvim; do
    ln -snf ~/dotfiles/$d ~/.config/$d
done

sudo update-alternatives --install \
    /usr/bin/x-terminal-emulator x-terminal-emulator "$(which alacritty)" 50

fish ~/dotfiles/setup/setup.fish
