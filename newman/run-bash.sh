#!/bin/bash

echo "  Collection URL:  " $COLLECTION_FILE
echo "  Environment URL: " $ENVIRONMENT_FILE
echo "  Global URL: " $GLOBAL_FILE
echo "  Global URL: " $APP_FILE

apt-get update -y
apt-get install python-pip -y
apt-get install jq -y
apt-get install nodejs -y
apt-get install npm -y
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
sed -i "s|TOKEN|$token|g" $GLOBAL_FILE
sed -i "s|TOKEN|$token|g" $COLLECTION_FILE

echo "Node Version:       " `node -v`
echo "NPM Version:        " `npm -v`
echo "Old Newman Version: " `newman --version`

echo "  Install newest newman version."
npm install newman --global --no-spin

echo "New Newman Version: " `newman --version`

# using the v3 syntax.
newman run $COLLECTION_FILE -e $ENVIRONMENT_FILE --bail

echo "Complete!"