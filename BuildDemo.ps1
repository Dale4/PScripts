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