param (
    [switch] $Clean,
    [parameter (Mandatory=$true)]
    [String] $solutionName = "websolution",
    [String] $webProjName = "web",
    [String] $webapiProjName = "webapi",
    [parameter (Mandatory=$true)]
    [String] $imagetag = "1.0.0"
)

$originalPath = $PWD.Path

$fullPath = Join-Path -Path $originalPath -ChildPath $solutionName

Write-Host "Start build ..." $fullPath

if (Test-Path -Path $fullPath) {
    $errorMessage = $fullPath + "Folder already exists.  Delete the folder and start over or change the solution name " + $solutionName
    Write-Error -M $errorMessage
    exit
}

try {

Write-Host "get latest .gitignore file from github"
curl -L -o .gitignore https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore    

Write-Host "Create solution " $solutionName
dotnet new sln --output $solutionName
cd $solutionName

Write-Host "Build Web Api project " $webapiProjName
#Build Web API project
dotnet new webapi --output $webapiProjName
dotnet sln add $webapiProjName
cd $webapiProjName
Write-Host "Publish image to local docker registry " $webapiProjName":"$imagetag
dotnet add package Microsoft.NET.Build.Containers
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
dotnet publish --os linux --arch x64 -p:PublishProfile=DefaultContainer -p:ContainerImageTag=$imagetag
cd ..

Write-Host "Build Web project " $webProjName
#Build Web Project
dotnet new web --output $webProjName
dotnet sln add $webProjName
cd $webProjName
Write-Host "Publish image to local docker registry " $webProjName":"$imagetag 
dotnet add package Microsoft.NET.Build.Containers
dotnet publish --os linux --arch x64 -p:PublishProfile=DefaultContainer -p:ContainerImageTag=$imagetag

Write-Host "Build Completed"
} catch {
    Write-Error "An error occurred: $_"
    exit 101  # Exit the script with a non-zero exit code
}


Set-Location -Path $originalPath
