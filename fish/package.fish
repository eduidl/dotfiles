function self_update
    pushd (dirname (status -f))
    git pull
    popd
    source $fish_scripts_dir/config.fish
end

function update
    self_update
    _update
end

function _update
    sudo apt update && sudo apt upgrade && sudo apt autoremove

    # Python
    rye self update
    python3 -m pip install pip -U

    # fish
    fisher update

    # Rust
    if command_exist rustup
        rustup update

        if ! which cargo-install-update
            cargo install cargo-update
        end

        cargo install-update -a
    end
end

function install_rust_dev
    cargo install \
        cargo-audit \
        cargo-edit \
        cargo-msrv \
        cargo-outdated \
        cargo-release \
        cargo-watch
end

function install_aws_cli
    pushd /tmp
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -u awscliv2.zip
    sudo ./aws/install --update
    popd
end
