function update_completions
    fish_update_completions

    set -l dir $__fish_config_dir/completions

    set completions \
        "poetry completions fish" \
        "rustup completions fish" \
        "gh completion \--shell fish" \
        "uv generate-shell-completion fish"

    for completion in $completions
        set args (string split ' ' $completion)
        if command_exist $args[1]
            eval (string join " " $args) >$dir/$args[1].fish
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
        ' >$dir/aws.fish
    end
end
