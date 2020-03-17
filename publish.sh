#!/bin/bash

# build it
yarn build

# remove the old stuff
rm -rf ~/vue-atlaskit-npm

#
mkdir ~/vue-atlaskit-npm

# copy the important stuff
cp -r src ~/vue-atlaskit-npm
cp -r dist ~/vue-atlaskit-npm

# copy over package spec, license and readme
cp package.json ~/vue-atlaskit-npm
cp LICENSE ~/vue-atlaskit-npm
cp README.md ~/vue-atlaskit-npm

# remove the example component
rm ~/vue-atlaskit-npm/src/App.vue

# remove the generated demo.html
rm ~/vue-atlaskit-npm/dist/demo.html

exit 0
