for abb in (abbr -l)
    abbr -e $abb
end

abbr mkdir mkdir -p

# git
abbr g git
abbr ga git add
abbr gb git branch
abbr gc git commit -m
abbr gca git commit --amend --no-edit
abbr gcv git commit -v
abbr gch git checkout
abbr gs git status

# docker
abbr d docker
abbr dc docker-compose

if command_exist nvim
    abbr vi nvim
    abbr vim nvim
else if command_exist vim
    abbr vi vim
end

if command_exist eza
    abbr ls eza
    abbr ll eza -lh
    abbr la eza -lha
    abbr tree eza -T
else
    abbr ll ls -l
    abbr la ls -al
end
