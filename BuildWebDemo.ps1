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

Write-Host "Start build ..."

dotnet new sln --output $solutionName
cd $solutionName

#Build Web API project
dotnet new webapi --output $webapiProjName
dotnet sln add $webapiProjName
cd $webapiProjName
dotnet add package Microsoft.NET.Build.Containers
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
dotnet publish --os linux --arch x64 -p:PublishProfile=DefaultContainer -p:ContainerImageTag=$imagetag
cd ..

#Build Web Project
dotnet new web --output $webProjName
dotnet sln add $webProjName
cd $webProjName
dotnet add package Microsoft.NET.Build.Containers
dotnet publish --os linux --arch x64 -p:PublishProfile=DefaultContainer -p:ContainerImageTag=$imagetag

Set-Location -Path $originalPath
