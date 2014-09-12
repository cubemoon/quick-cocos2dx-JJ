@echo off
set QUICK=D:\quick-cocos2d-x\project\framework\player\bin\win32\quick-x-player.exe
set PROJECT=%cd%
set SIZE=854x480
start "Quick X Player " "%QUICK%" -workdir %PROJECT% -file %PROJECT%\scripts\main.lua -size %SIZE%
