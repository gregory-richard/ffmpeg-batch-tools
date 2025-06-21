@echo off
setlocal

for %%a in (%*) do (
    if "%%~xa"==".mp4" (
        echo Processing: %%a
        
        :: Create directory for frames if it doesn't exist.
        if not exist "%%~dpna\" mkdir "%%~dpna"
        
        :: Extract frames.
        ffmpeg -i "%%~a" "%%~dpna\%%06d.jpeg" -loglevel error

        :: Extract audio from the video
        ffmpeg -i "%%~a" -q:a 0 -map a "%%~dpna\original_audio.aac" -loglevel error
        
        :: Extract framerate and save it in a text file inside the frames directory.
        ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "%%~a" > "%%~dpna\framerate.txt"
    )
)

endlocal
pause