echo "--> to pub..."
rm -rf ./public
zola build
cd public
cp ../CNAME ./
git init -b gh-pages
git config user.email "joinbase0@joinbase.io"
git config user.name joinbase0
git add -A .
git commit -m"pub"
git remote add origin git@joinbase:open-joinbase/joinbase.io.git
git push --force -u origin gh-pages
echo "--> pub done"