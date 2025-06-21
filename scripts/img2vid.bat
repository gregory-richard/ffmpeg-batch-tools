@echo off
setlocal enabledelayedexpansion

:: For each folder dropped onto the script
for /D %%d in (%*) do (
    :: Initialize variables
    set "framerate="
    set "includeAudio=-an"
    set "fileNumber=1"

    :: Rename PNG files to a consistent naming pattern
    for %%f in ("%%~d\*.png") do (
        set "newFileName=000000"
        set "newFileName=!newFileName!!fileNumber!.png"
        set "newFileName=!newFileName:~-10!"
        ren "%%f" "!newFileName!"
        set /a fileNumber+=1
    )
    
    :: Check if the framerate.txt file exists in the folder
    if exist "%%~d\framerate.txt" (
        :: Read the framerate from the text file
        set /p framerate=<"%%~d\framerate.txt"
    ) else (
        :: Prompt for framerate
        echo No framerate.txt found in "%%~d".
        set /p framerate="Please enter a framerate (e.g., 24, 30, 60): "
        if "!framerate!"=="" (
            echo No framerate was entered. Skipping folder.
            goto SkipFolder
        )
    )

    :: Check if the original_audio.aac file exists
    if exist "%%~d\original_audio.aac" (
        set "includeAudio=-i "%%~d\original_audio.aac" -c:a aac -strict experimental"
    )

    :: Use ffmpeg to stitch the renamed images back to a video using the stored or provided framerate
    ffmpeg -framerate !framerate! -i "%%~d\%%06d.png" !includeAudio! -c:v libx264 -pix_fmt yuv420p "%%~dpd%%~nxd_conv.mp4" -loglevel error
)

:SkipFolder
endlocal
pause