# clean up demo folder
Remove-Item -Recurse ./demo1/ -Force 
rm -rf ./demo

# run command and put projects into demo folder
./BuildWebDemo.ps1 -solutionName demo1 -imagetag 1.1.8 > $null 2>&1

# remove generated docker images
docker rmi $(docker images -q 'web*')

# run curl command to get the latest c# .gitignore file
curl -L -o .gitignore https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore