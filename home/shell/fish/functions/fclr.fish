function fclr --description 'A fake clear, just echo empty lines'
if not test -z $argv[1]
set -f fclr_lines $argv[1]
end
if test -z $fclr_lines
set -f fclr_lines 20
end
for i in (seq $fclr_lines)
echo ""
end
end
