# Go to project > Repository and set the branch filter
# Then click on "View Key" and paste it on github
dart --version
pub get

echo "\n> Ensure that the code is warning free"
dartanalyzer lib/oauth2.dart || exit 1
dartanalyzer lib/google.dart || exit 1
dartanalyzer lib/facebook.dart || exit 1
dartanalyzer lib/windows_live.dart || exit 1
# dartanalyzer test/test.dart || exit 1

# echo "\n> Run tests"
# dart --enable-type-checks --enable-asserts test/test.dart || exit 1

#echo "> Run build"
#pub build || exit 1

echo "\n> Generate docs"
dartdoc lib/oauth2.dart lib/google.dart lib/facebook.dart lib/windows_live.dart --package-root=packages

echo "\n> Copy docs up to github gh-pages branch"
mv docs docs-tmp
git checkout gh-pages
rm -Rf docs
mv docs-tmp docs
date > date.txt
git add -A
git commit -m"auto commit from drone.io"
git remote set-url origin git@github.com:christophehurpeau/dart-simple_oauth2_server.git
git push origin gh-pages

