#!/bin/bash

echo "  Collection URL:  " $COLLECTION_FILE
echo "  Environment URL: " $ENVIRONMENT_FILE
echo "  Global URL: " $GLOBAL_FILE

apt-get update
apt-get install python-pip
apt-get install jq -y
apt-get install curl -y
pip install locustio -y

server=`jq '.values[1].value' $ENVIRONMENT_FILE`
ser=`echo $server | sed 's/"//g'`
echo "Server: $ser"
port=`jq '.values[0].value' $ENVIRONMENT_FILE`
po=`echo $port | sed 's/"//g'`
echo "Port: $po"
host_url="http://$ser:$po/auth/login"
echo "hosturl: $host_url"

response=$(python newman-repo/app.py 2>&1 > /dev/null)
token=`echo $response | jq ".token"`
echo "Token: $token"
#basic_login_curl=$(curl -w "200" -s -X POST -d '{"username":"gauravdabhade24@gmail.com","password":"password"}' $host_url)
#echo "login response: $basic_login_curl"
#auth_token=echo $basic_login_curl | jq '.auth_token'
#echo "auth_token: $auth_token"
sed -i "s|TOKEN|$token|g" $GLOBAL_FILE

echo "Complete!"