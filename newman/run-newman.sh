#!/bin/bash

echo "Checking for NPM"
echo "  Collection URL:  " $COLLECTION_FILE
echo "  Environment URL: " $ENVIRONMENT_FILE
echo "  Global URL: " $GLOBAL_FILE

echo "Node Version:       " `node -v`
echo "NPM Version:        " `npm -v`
echo "Old Newman Version: " `newman --version`

echo "  Install newest newman version."
npm install newman --global --no-spin

echo "New Newman Version: " `newman --version`

# using the v3 syntax.
newman run $COLLECTION_FILE -e $ENVIRONMENT_FILE --bail

echo "Complete!"