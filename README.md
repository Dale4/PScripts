# PScripts
Location where I keep my power shell scripts 

# run command
./BuildWebDemo.ps1 -solutionName demo1 -imagetag 1.1.8 > $null 2>&1

# remove docker images
docker rmi $(docker images -q 'web*')
