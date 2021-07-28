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

    # Development tools are managed by mise.
    mise self-update --yes
    mise upgrade --yes

    # fish
    fisher update
end
