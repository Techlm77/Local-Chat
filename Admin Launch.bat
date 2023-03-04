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
echo %username% >> ".\userlist.txt"
start cmd /c "..\Room %room_number%\DisplayRoom.bat"
title Chatting as %username%
echo. >>"..\Room %room_number%\chat.txt"
echo %time% - %username% has joined the room >>"..\Room %room_number%\chat.txt"

:read_messages_room
cls
mode con: cols=54 lines=4
set /p input=Message:
if /I "%input%" == "/clear" goto clear
if /I "%input%" == "/change" goto change_room
if /I "%input%" == "/help" goto help
if /I "%input%" == "/quit" goto quit
if /I "%input:~0,5%" == "/kick" goto kick_user
if /I "%input:~0,4%" == "/ban" goto ban_user
if /I "%input:~0,3%" == "/op" goto op_user
if "%input%" == "" goto read_messages_room
echo %time% - %username%: %input% >>"..\Room %room_number%\chat.txt"
set input=
goto read_messages_room

:help
cls
mode con: cols=54 lines=11
echo 1. /help 
echo 2. /quit 
echo 3. /change 
echo 4. /clear (admin only)
echo 5. /kick [username] 
echo 6. /ban [username] 
echo 7. /op [username] 
echo.
echo [Note]: /ban and /op commands require admin access.
pause
goto read_messages_room

:kick_user
set user_to_kick=%input:~6%
findstr /i /m /c:"%user_to_kick%" ".\userlist.txt" >nul 2>&1
if %errorlevel%==0 (
    for /f "delims=" %%i in ('type ".\userlist.txt" ^| find /v "%user_to_kick%"') do echo %%i>>".\userlist_new.txt"
    move /y ".\userlist_new.txt" ".\userlist.txt" >nul 2>&1
    echo %time% - %user_to_kick% has been kicked by %username%. >>"..\Room %room_number%\chat.txt"
    echo You have kicked %user_to_kick% from the room.
    goto read_messages_room
) else (
    echo User not found in the room.
    goto read_messages_room
)

:ban_user
findstr /i /m /c:"%username%" ".\userlist.txt" >nul 2>&1
if %errorlevel%==0 (
    set user_to_ban=%input:~5%
    findstr /i /m /c:"%user_to_ban%" ".\userlist.txt" >nul 2>&1
    if %errorlevel%==0 (
        echo %time% - %user_to_ban% has been banned by %username%. >>"..\Room %room_number%\chat.txt"
        echo You have banned %user_to_ban% from the room.
        echo %user_to_ban% >>".\banned_users.txt"
        goto read_messages_room
    ) else (
        echo User not found in the room.
        goto read_messages_room
    )
)

:op_user
findstr /i /m /c:"%username%" ".\userlist.txt" >nul 2>&1
if %errorlevel%==0 (
set user_to_op=%input:~4%
findstr /i /m /c:"%user_to_op%" ".\userlist.txt" >nul 2>&1
if %errorlevel%==0 (
echo %time% - %user_to_op% has been promoted to operator by %username%. >>"..\Room %room_number%\chat.txt"
echo You have promoted %user_to_op% to operator.
echo %user_to_op% >>".\operators.txt"
goto read_messages_room
) else (
echo User not found in the room.
goto read_messages_room
)
) else (
echo You do not have admin access.
goto read_messages_room
)

:quit
echo %time% - %username% has left the room. >>"..\Room %room_number%\chat.txt"
exit

:clear
findstr /v "^" ".\chat.txt" >".\chat_backup.txt"
del ".\chat.txt"
echo %time% - %username% has cleared the chat history. >>"..\Room %room_number%\chat.txt"
goto read_messages_room

:change_room
echo %time% - %username% has left the room. >>"..\Room %room_number%\chat.txt"
cd ..
goto mainMenu

:exitChat
exit

:banCheck
set "banned="
for /f "usebackq delims=" %%a in (".\banned_users.txt") do (
if /i "%username%"=="%%a" (
set "banned=true"
)
)
if defined banned (
echo You have been banned from this room.
exit ) else (
goto username
)

:operatorCheck
set "operator="
for /f "usebackq delims=" %%a in (".\operators.txt") do (
if /i "%username%"=="%%a" (
set "operator=true"
)
)
if defined operator (
echo You have operator access.
) else (
echo You do not have operator access.
)
goto read_messages_room

:username
set /p username=Username:
call :banCheck
call :operatorCheck
echo %username% >>".\userlist.txt"
goto room1
