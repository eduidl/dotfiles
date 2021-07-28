function update_completions
    fish_update_completions

    set -l dir $__fish_config_dir/completions

    for cmd in poetry rustup
        if command_exist $cmd
            $cmd completions fish >$dir/$cmd.fish
        end
    end

    for cmd in gh
        if command_exist $cmd
            $cmd completion --shell fish >$dir/$cmd.fish
        end
    end

    if command_exist register-python-argcomplete
        for cmd in pipx
            if command_exist $cmd
                register-python-argcomplete --shell fish $cmd >$dir/$cmd.fish
            end
        end
    end

    if command_exist aws
        string trim '
            complete -c aws -f -a "(
                begin
                    set -lx COMP_SHELL fish
                    set -lx COMP_LINE (commandline)
                    aws_completer
                end
            )"
        ' > $dir/aws.fish
    end
end
