@echo off
pushd "%~dp0"

if exist RedistPackages rd /s /q RedistPackages
if not exist RedistPackages\libs mkdir RedistPackages\libs
if not exist RedistPackages\symbols mkdir RedistPackages\symbols

rem CSPROJ and NUSPEC Build

set project=jose-jwt.net40
.nuget\nuget.exe pack "jose-jwt\%project%.csproj" -Build -Symbols -IncludeReferencedProjects -OutputDirectory "RedistPackages\libs" -Properties configuration=Release


for /f %%v in ('dir /b /s RedistPackages\libs\*.symbols.nupkg') do move %%v RedistPackages\symbols\
for /f %%v in ('dir /b /s RedistPackages\symbols\*.symbols.nupkg') do .nuget\nuget.exe push %%v -s http://PACKAGE_SERVER/symbols/NuGet/ -ApiKey KEY
for /f %%v in ('dir /b /s RedistPackages\libs\*.nupkg') do .nuget\nuget.exe push %%v -s http://PACKAGE_SERVER/libs/ -ApiKey KEY

start RedistPackages

popd
@echo on