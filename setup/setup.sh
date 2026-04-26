#!/bin/bash

set -eo pipefail

env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

PATH=${PATH}:$HOME/.local/bin

# PPA
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:git-core/ppa

sudo apt update
sudo apt install -y \
    build-essential \
    ca-certificates \
    ccache \
    curl \
    git \
    gnupg \
    libssl-dev \
    lsb-release \
    ninja-build \
    python3-dev \
    python3-venv \
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

# mise
curl https://mise.run | sh

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
for lib in clang-format; do
    uv tool install $lib
done

# Rust
# https://www.rust-lang.org/tools/install
rustup toolchain add beta
cargo install cargo-binstall
cargo binstall \
    cargo-update

# Terminal
sudo apt install cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
cargo binstall \
    alacritty \
    zellij

# symlinks
mkdir -p ~/.config/fish/
ln -snf ~/dotfiles/fish/config.fish ~/.config/fish/config.fish

for d in alacritty git mise; do
    ln -snf ~/dotfiles/$d ~/.config/$d
done

mkdir -p ~/.codex
for d in config.toml prompts rules; do
    ln -snf ~/dotfiles/codex/$d ~/.codex/$d
done

sudo update-alternatives --install \
    /usr/bin/x-terminal-emulator x-terminal-emulator "$(which alacritty)" 50

fish ~/dotfiles/setup/setup.fish
