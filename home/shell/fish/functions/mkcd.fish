function mkcd --description 'Make a dir and enter it'
if test -z $argv[1]
echo "A directory path is required in the paramter"
return 1
end
if test -f $argv[1]
echo "The target is a file!"
return 1
end
mkdir -p $argv[1]
cd $argv[1]
end
