#!/bin/bash

echo "  Collection URL:  " $COLLECTION_FILE
echo "  Environment URL: " $ENVIRONMENT_FILE
echo "  Global URL: " $GLOBAL_FILE
echo "  Global URL: " $APP_FILE

apt-get update -y
apt-get install python-pip -y
apt-get install jq -y
pip install requests

server=`jq '.values[1].value' $ENVIRONMENT_FILE`
ser=`echo $server | sed 's/"//g'`
echo "Server: $ser"
port=`jq '.values[0].value' $ENVIRONMENT_FILE`
po=`echo $port | sed 's/"//g'`
echo "Port: $po"
host_url="http://$ser:$po/auth/login"
echo "hosturl: $host_url"

response=$(python $APP_FILE)
token=`echo $response | jq ".token"`
echo "Token: $token"
token=`echo $token | sed 's/"//g'`
#basic_login_curl=$(curl -w "200" -s -X POST -d '{"username":"gauravdabhade24@gmail.com","password":"password"}' $host_url)
#echo "login response: $basic_login_curl"
#auth_token=echo $basic_login_curl | jq '.auth_token'
#echo "auth_token: $auth_token"
sed -i "s|TOKEN|$token|g" $GLOBAL_FILE
sed -i "s|TOKEN|$token|g" $COLLECTION_FILE

echo "Complete!"