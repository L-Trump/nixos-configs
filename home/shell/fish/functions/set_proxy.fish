function set_proxy
not test -z $argv[1]; and set -f proxy $argv[1]
or set -f proxy "http://localhost:7893"
echo $proxy | string trim | string lower | string match -qr "^https?://"
or set -f proxy "http://$proxy"
echo "Set proxy to $proxy ..."
set -gx HTTP_PROXY $proxy
set -gx HTTPS_PROXY $proxy
set -gx ALL_PROXY $proxy
end
