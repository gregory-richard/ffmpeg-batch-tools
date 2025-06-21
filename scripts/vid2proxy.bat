@echo off
setlocal

:: Check if FFmpeg is installed
where ffmpeg >nul 2>&1
if %errorlevel% neq 0 (
    echo FFmpeg is not installed or not in PATH.
    pause
    exit /b
)

:: Get the file path from the drag-and-drop or from the user input
set "inputVideo=%~1"
if "%inputVideo%"=="" (
    echo Please drag a video file onto this script or provide the file path as an argument.
    pause
    exit /b
)

:: Create the proxy directory if it doesn't exist
set "proxyDir=%~dp1proxy"
if not exist "%proxyDir%" mkdir "%proxyDir%"

:: Define the output file name and path
set "outputVideo=%proxyDir%\%~n1_proxy.mp4"

:: Execute FFmpeg command to create a proxy file
ffmpeg -stats -i "%inputVideo%" -vf "scale=-2:480:flags=lanczos" -c:v libx264 -preset ultrafast -crf 30 "%outputVideo%" -hide_banner -loglevel error

echo.
echo Proxy created: "%outputVideo%"
pause