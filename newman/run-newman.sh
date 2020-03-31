#!/bin/bash

echo "Checking for NPM"
echo "  Collection URL:  " $COLLECTION_URL
echo "  Environment URL: " $ENVIRONMENT_URL
echo "  Global URL: " $GLOBAL_URL

echo "Node Version:       " `node -v`
echo "NPM Version:        " `npm -v`
echo "Old Newman Version: " `newman --version`

echo "  Install newest newman version."
npm install newman --global --no-spin

echo "New Newman Version: " `newman --version`

server = `jq '.values[1].value' $ENVIRONMENT_URL
echo "Server: " $server
port = `jq '.values[2].value' $ENVIRONMENT_URL
echo "Port: " $port
host_url = "http://"$server":"$port"/auth/login"
echo "hosturl: " $host_url
basic_login_curl=$(curl -w "200" -s -X POST -d "username=gauravdabhade24@gmail.com&password=password" "$host_url")
echo "login response: " $basic_login_curl
auth_token = echo $basic_login_curl | jq '.auth_token'
echo "auth_token: " $auth_token
sed -i "s|TOKEN|$auth_token|g" $GLOBAL_URL

# using the v3 syntax.
newman run $COLLECTION_URL -e $ENVIRONMENT_URL --globals $GLOBAL_URL --bail

echo "Complete!"