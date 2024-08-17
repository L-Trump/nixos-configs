function copypath
set -l file $argv[1]; or set -l file '.'

if not string match -r '^/' $file
set file (realpath "$PWD/$file")
end

echo -n (string escape $file) | fish_clipboard_copy 
or return 1

printf "%s%s%s copied to clipboard.\n" (set_color -o) $file (set_color normal)
end
