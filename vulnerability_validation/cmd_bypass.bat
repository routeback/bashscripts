Windows Command Prompt / PowerShell Access - Save as .bat

@echo off
rem Bypass Windows CMD Restriction
rem                          /***   Platform: All Windows Versions   ***/
rem                          /***
rem                                 Description: This batch scripting file can bypass
rem                                 the cmd.exe restriction ( when the prompt command
rem                                 say : "The command prompt has been disabled by your administrator" )
rem                          ***/
set chdir=chdir
color F0
:top
set command=rem
%chdir%
set /p command=Command:
%command%
echo.
goto top
