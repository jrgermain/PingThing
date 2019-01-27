@echo off

rem --------------------------------------------------------------------------
rem PingThing - Quickly ping a list of servers and see if they respond
rem v1.0 - January 2019 - Joey Germain
rem --------------------------------------------------------------------------

title PingThing
echo Initializing...

rem Get number of servers to ping
set /a numServers=0
for /f %%a in (machineList.txt) do set /a numServers+=1

rem Build output csv file -- will overwrite existing result.csv if it exists
echo Server, Result > result.csv

rem Perform tests and append results to output file
cls
echo Performing tests...
set /a currentServer=0
for /f "tokens=*" %%a in (machineList.txt) do call :pingServer %%a >> result.csv

rem Clean up temporary files
del %temp%\pingthing.txt

rem Open results
start result.csv


rem --------------------------------------------------------------------------
rem Server ping subroutine
rem --------------------------------------------------------------------------

:pingServer

ping -n 1 -w 2500 %1 > %temp%\pingthing.txt

find "could not find host" %temp%\pingthing.txt > nul
if not errorlevel 1 (
    echo %1, Could not find host
    exit /b
)

find "Request timed out" %temp%\pingthing.txt > nul
if not errorlevel 1 (
    echo %1, Request timed out
    exit /b
)

echo %1, Ok

set /a currentServer+=1
title PingThing - %currentServer%/%numServers%

exit /b
