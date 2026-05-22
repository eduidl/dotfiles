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

function init_repo
    set -l visibility $argv[1]
    if [ $visibility != private -a $visibility != public ]
        echo "Invalid visibility: $visibility"
        return 1
    end

    git init
    git commit -m "Initial commit" --allow-empty
    set -l repo_name (basename (pwd))
    gh repo create eduidl/$repo_name --$visibility --source=. --remote=origin --push
end

function init_private_repo
    init_repo private
end

function init_public_repo
    init_repo public
end
