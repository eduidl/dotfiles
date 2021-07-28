function command_exist
    if type $argv[1] >/dev/null 2>&1
        return 0
    else
        echo $argv[1]: not found
        return 1
    end
end

function del_tag
    git tag --delete $argv[1]
    git push origin :$argv[1]
end

function clean_tags
    for tag in $(git tag -l "$argv[1]/*")
        del_tag $tag
    end
end
