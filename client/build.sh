#!/bin/bash

rm -rf ../dist/client

npx rollup -c

mkdir -p ../dist/client/assets

cp -r ./dist/bundle.js ./src/style ../dist/client
cp -r ../assets/ui/buttons ../dist/client/assets

echo "var gameSdkTypes = \`$(cat ./src/typedefs/sdk.d.ts)\`" > ../dist/client/sdk-types.js
