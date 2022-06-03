@echo off
color 06
mode con: cols=60 lines=25
title Chat Room

:home
if not exist ".\chat.txt" goto create
cls
type .\chat.txt
echo.
timeout /t 1 >nul
goto home

:create
echo        __                     __   ________          __  >>.\chat.txt
echo       / /   ____  _________ _/ /  / ____/ /_  ____ _/ /_ >>.\chat.txt
echo      / /   / __ \/ ___/ __ `/ /  / /   / __ \/ __ `/ __/ >>.\chat.txt
echo     / /___/ /_/ / /__/ /_/ / /  / /___/ / / / /_/ / /_   >>.\chat.txt
echo    /_____/\____/\___/\__,_/_/   \____/_/ /_/\__,_/\__/   >>.\chat.txt
echo          LocalChat developed by Dominic J Young >>.\chat.txt
echo.  >>.\chat.txt
echo                           Room 2 >>.\chat.txt
goto home