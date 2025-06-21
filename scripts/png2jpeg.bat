@echo off
setlocal enabledelayedexpansion

:: For each folder dropped onto the script
for /D %%d in (%*) do (
    echo Converting PNG files to JPEG in "%%~d"

    :: Convert all PNG files to JPEG
    for %%f in ("%%~d\*.png") do (
        set "jpgFileName=%%~dpnf.jpg"
        ffmpeg -i "%%f" "!jpgFileName!" -loglevel error
    )

    :: Ask user if PNG files should be deleted
    set /p deletePngs="Do you want to delete the original PNG files? (Y/N): "
    if /i "!deletePngs!"=="Y" (
        del "%%~d\*.png"
        echo Original PNG files deleted.
    ) else (
        echo Original PNG files kept.
        set /p movePngs="Do you want to move the PNG files to a 'png' subfolder? (Y/N): "
        if /i "!movePngs!"=="Y" (
            if not exist "%%~d\png" mkdir "%%~d\png"
            move "%%~d\*.png" "%%~d\png"
            echo PNG files moved to 'png' subfolder.
        ) else (
            echo PNG files remain in the original location.
        )
    )
)

endlocal
pause