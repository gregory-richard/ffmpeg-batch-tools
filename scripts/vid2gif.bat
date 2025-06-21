@echo off
setlocal enabledelayedexpansion

rem Define variables to store width, height, framerate, and previous values
set width_currvid=
set width_prevvid=
set width_currgif=
set width_prevgif=

set height_currvid=
set height_prevvid=
set height_currgif=
set height_prevgif=

set framerate_currvid=
set framerate_prevvid=
set framerate_currgif=
set framerate_prevgif=

rem Initialize a counter
set count=0

rem Loop through the arguments to count them
for %%A in (%*) do (
    set /a count+=1
)

echo Total number of files: !count!
echo.

for %%A in (%*) do (
    echo --------------------------------
    
    rem Getting video properties
    ffprobe -v error -hide_banner -select_streams v:0 -show_entries stream=width,height,r_frame_rate -of default=noprint_wrappers=1 -i %%A > temp.txt
    for /f "tokens=1,2 delims==" %%a in (temp.txt) do (
        if "%%a"=="width" (
            set width_currvid=%%b
        ) else if "%%a"=="height" (
            set height_currvid=%%b
        ) else if "%%a"=="r_frame_rate" (
            for /f "tokens=1,2 delims=/" %%i in ("%%b") do (
                set num=%%i
                set den=%%j
            )
            if not defined den (
                set framerate_currvid=!num!
            ) else (
                set /a "int_div=num/den"
                set /a "remainder=num%%den * 1000 / den"
                set framerate_currvid=!int_div!.!remainder!
                if "!framerate_currvid!"=="23.976" (
                    set framerate_currvid=23.976
                )
            )
            set num=
            set den=
        )
    )

    del temp.txt

    echo "%%~nxA"
    echo !framerate_currvid!fps, !width_currvid!x!height_currvid!
    echo.

    :inputCheck
    rem Check if properties are the same as the previous file or if this is the first file
    if not "!width_currvid!!height_currvid!!framerate_currvid!"=="!width_prevvid!!height_prevvid!!framerate_prevvid!" (
        set /p customValues="Press enter to accept the fps and resolution from video or enter custom values for GIF: "

        if "!customValues!"=="" (
            set width_currgif=!width_currvid!
            set height_currgif=!height_currvid!
            set framerate_currgif=!framerate_currvid!

        )else (
        
            echo !customValues! | findstr /r "^[0-9][0-9]*, *[0-9][0-9]*x[0-9][0-9]*$" >nul
            if errorlevel 1 (
                echo Invalid format! Please enter values in the format "fps, widthxheight".
                goto inputCheck
            ) else (
                for /f "tokens=1,2 delims=, " %%i in ("!customValues!") do (
                    set framerate_currgif=%%i
                    set dims=%%j
                )
                for /f "tokens=1,2 delims=x" %%i in ("!dims!") do (
                    set width_currgif=%%i
                    set height_currgif=%%j
                )
            )
        )



    ) else (
        echo Video has same resolution as previous. Proceeding with previous GIF parameters ^(!framerate_prevgif!, !width_prevgif!x!height_prevgif!^).
        set width_currgif=!width_prevgif!
        set height_currgif=!height_prevgif!
        set framerate_currgif=!framerate_prevgif!
    )

    rem Conversion using FFmpeg
    echo Converting "%%~nxA" to GIF...
    echo.
    ffmpeg -i %%A -vf "fps=!framerate_currgif!,scale=!width_currgif!:-1" -loop 0 "%%~nA.gif" -y -loglevel error
        
    set width_prevgif=!width_currgif!
    set height_prevgif=!height_currgif!
    set framerate_prevgif=!framerate_currgif!

    set width_prevvid=!width_currvid!
    set height_prevvid=!height_currvid!
    set framerate_prevvid=!framerate_currvid!
)

echo --------------------------------
echo All videos converted
echo.
echo --------------------------------

echo Enter a file size limit [MB] to be checked or enter to close this window:
set /p fileSizeLimit=
echo.
echo --------------------------------
if not defined fileSizeLimit exit

:: Loop through the passed arguments
for %%F in (%*) do (

    :: Construct the GIF file path
    set "gifPath=%%~dpnF.gif"

    :: Check if the GIF file exists
    if exist "!gifPath!" (
        
        :: Fetch and display the file size in bytes
        for %%G in ("!gifPath!") do (
            set "sizeBytes=%%~zG"
            set /a "fileSize=sizeBytes / 1024 / 1024"
        )
        
        :: Check if the file size exceeds the limit
        if !fileSize! gtr !fileSizeLimit! (
            echo "%%~nxF"
            echo Exceeds limit ^(!fileSize!MB^)
            echo.
            echo --------------------------------
        )
        
    ) else (
        echo No corresponding GIF file found.
    )
)

echo script ended
pause