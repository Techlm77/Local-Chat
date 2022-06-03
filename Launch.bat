@echo off
mode con: cols=63 lines=25
color 06
title LAN CMD Chat by Dominic J Young

:mainMenu
set "room_number="
cls
echo "    _____      __          __     ____                       "
echo "   / ___/___  / /__  _____/ /_   / __ \____  ____  ____ ___  "
echo "   \__ \/ _ \/ / _ \/ ___/ __/  / /_/ / __ \/ __ \/ __ `__ \ "
echo "  ___/ /  __/ /  __/ /__/ /_   / _, _/ /_/ / /_/ / / / / / / "
echo " /____/\___/_/\___/\___/\__/  /_/ |_|\____/\____/_/ /_/ /_/  "
echo "                                                             "
echo " List of rooms that are available                            "
echo " - Room 1 [1]                                                "
echo " - Room 2 [2]                                                "
echo " - Room 3 [3]                                                "
echo " - Exit [4]                                                  "
set /p room_number=Room:
if %room_number% == 4 goto exitChat

:room1
cls
cd ".\Room %room_number%\"

:username
start cmd /c "..\Room %room_number%\DisplayRoom.bat"
title Chatting as %username%
echo. >>"..\Room %room_number%\chat.txt"
echo %time% - %username% has joined the room >>"..\Room %room_number%\chat.txt"

:read_messages_room
cls
mode con: cols=54 lines=4
set /p input=Message:
if /I "%input%" == "/change" goto change_room
if /I "%input%" == "/clear" goto clear
if /I "%input%" == "/help" goto help
if /I "%input%" == "/quit" goto quit
if "%input%"=="" goto read_messages_room
echo %time% - %username%: %input% >>"..\Room %room_number%\chat.txt"
set input=
goto read_messages_room

:help
cls
mode con: cols=54 lines=8
echo 1. /help 
echo 2. /quit 
echo 3. /change 
echo 4. /clear (admin only)
echo 5. /kick [username] (coming soon) 
echo 6. /ban [username] (coming soon) 
echo 7. /op [username] (coming soon) 
pause
goto read_messages_room

:clear
echo You have to be admin to run this command.
pause
goto read_messages_room

:change_room
echo Please close the display chat.
pause
cd ..
mode con: cols=63 lines=25
goto mainMenu

:create_chat
echo        __                     __   ________          __  >>.\chat.txt
echo       / /   ____  _________ _/ /  / ____/ /_  ____ _/ /_ >>.\chat.txt
echo      / /   / __ \/ ___/ __ `/ /  / /   / __ \/ __ `/ __/ >>.\chat.txt
echo     / /___/ /_/ / /__/ /_/ / /  / /___/ / / / /_/ / /_   >>.\chat.txt
echo    /_____/\____/\___/\__,_/_/   \____/_/ /_/\__,_/\__/   >>.\chat.txt
echo          LocalChat developed by Dominic J Young >>.\chat.txt
echo.  >>.\chat.txt
echo                           Room %room_number% >>.\chat.txt
echo.  >>.\chat.txt
goto read_messages_room

:quit
echo %time% - %username% has left the room >>".\chat.txt"
timeout /t 1 >nul
TASKKILL /F /IM cmd.exe /T
goto read_messages_room

:exitChat
exit