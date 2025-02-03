#!/bin/bash

rm -rf ../dist/client

npx rollup -c

mkdir -p ../dist/client

cp -r ./dist/bundle.js ./src/style ../dist/client

echo "var gameSdkTypes = \`$(cat ./src/typedefs/sdk.d.ts)\`" > ../dist/client/sdk-types.js
