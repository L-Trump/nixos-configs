function gwip --description 'git commit a work-in-progress branch'
    git add -A
    git rm (git ls-files --deleted) 2>/dev/null
    git commit -m --wip-- --no-verify --no-gpg-sign
end
