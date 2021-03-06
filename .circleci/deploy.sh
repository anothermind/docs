#!/usr/bin/env bash
pwd
remote=$(git config remote.origin.url)
described_rev=$(git rev-parse HEAD | git name-rev --stdin)
pages_dir="/documents/output"
mkdir gh-pages-branch
cd gh-pages-branch
git config --global user.email "${CIRCLE_PROJECT_USERNAME}" > /dev/null 2>&1
git config --global user.name "${CIRCLE_PROJECT_USERNAME}@${CIRCLE_PROJECT_USERNAME}" > /dev/null 2>&1
git init
git remote add --fetch origin "$remote"
if git rev-parse --verify origin/gh-pages > /dev/null 2>&1
then
    git checkout gh-pages
    git rm -rf .
else
    git checkout --orphan gh-pages
fi
cp -a "../${pages_dir}/." .
git add -A
git commit --allow-empty -m "Deploy to GitHub pages at ${described_rev} [ci skip]"
git push --force --quiet origin gh-pages > /dev/null 2>&1
cd ..
rm -rf gh-pages-branch
echo "Finished Deployment!"