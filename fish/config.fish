set -g fish_scripts_dir ~/dotfiles/fish
set -xp LD_LIBRARY_PATH /usr/local/lib

source $fish_scripts_dir/utility.fish

for bin_dir in ~/.local ~/.cargo ~/go /usr/local/go ~/.deno
    if test -e $bin_dir/bin
        fish_add_path $bin_dir/bin
    end
end

if test -f ~/.rye/env
    bass source ~/.rye/env
end

if test -e /usr/local/cuda
    set -x CUDA_PATH /usr/local/cuda
    set -xp CPATH $CUDA_PATH/include
    fish_add_path $CUDA_PATH/bin
    set -xp LIBRARY_PATH $CUDA_PATH/lib64
    set -xp LD_LIBRARY_PATH $CUDA_PATH/lib64
end

# config of bobthefish
# https://github.com/oh-my-fish/theme-bobthefish
set -g theme_display_git_master_branch yes # master branchの表示
set -g theme_display_date no # 日付の非表示
set -g theme_newline_cursor yes # コマンド入力を行頭にする（改行しておく）

set -x VIRTUAL_ENV_DISABLE_PROMPT 1 # disable the default virtualenv prompt
set -x PIPENV_VENV_IN_PROJECT true

set -x nvm_default_version lts

if command_exist fd
    set -x FZF_DEFAULT_COMMAND 'fd --type file --color always --exclude .git'
    set -x FZF_DEFAULT_OPTS --ansi
    set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
end

for i in abbr completion package ros
    source $fish_scripts_dir/$i.fish
end

set -l path $fish_scripts_dir/work/config.fish
if test -f $path
    source $path
end
