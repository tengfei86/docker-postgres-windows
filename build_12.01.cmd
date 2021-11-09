@echo off
SETLOCAL EnableDelayedExpansion
set repoName=distservices-docker-release.repo.openearth.io/distarch/devops/postgres-windows
set docker_username=%~1
set docker_password=%~2
if [%docker_username%] == []  (
  exit /B 1 
) else if [%docker_password%] == [] (
  exit /B 1 
)

docker login %repoName% -p %docker_username% -u %docker_password% 
:image_build
    set winVer=%~1
    set edbVer=%~2
    set pgVer=%edbVer:~0,-2%

    docker build ^
        --build-arg WIN_VER=%winVer% ^
        --build-arg EDB_VER=%edbVer% ^
        --tag %repoName%:%pgVer%-%winVer% ^
        .
    docker push %repoName%:%pgVer%-%winVer%
EXIT /B 0

docker pull mcr.microsoft.com/windows/servercore:1909

docker pull mcr.microsoft.com/windows/nanoserver:1909

call :image_build 1909 12.0-1


