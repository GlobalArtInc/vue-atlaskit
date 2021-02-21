#!/usr/bin/env sh
# abort on errors
set -e
# build
yarn run gh:build
# navigate into the build output directory
cd dist
# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME
git init
git add -A
git commit -m 'deploy'
git push -f https://github.com/GlobalArtLimited/vue-atlaskit.git master:gh-pages
cd -
