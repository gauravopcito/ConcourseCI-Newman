#!/bin/bash

echo "  Collection URL:  " $COLLECTION_URL
echo "  Environment URL: " $ENVIRONMENT_URL
echo "  Global URL: " $GLOBAL_URL

server=`jq '.values[1].value' $ENVIRONMENT_URL`
echo "Server: " $server
port=`jq '.values[2].value' $ENVIRONMENT_URL`
echo "Port: " $port
host_url="http://"$server":"$port"/auth/login"
echo "hosturl: " $host_url
basic_login_curl=$(curl -w "200" -s -X POST -d "username=gauravdabhade24@gmail.com&password=password" "$host_url")
echo "login response: " $basic_login_curl
auth_token=echo $basic_login_curl | jq '.auth_token'
echo "auth_token: " $auth_token
sed -i "s|TOKEN|$auth_token|g" $GLOBAL_URL

echo "Complete!"