# FFmpeg Batch Tools

A collection of Windows batch scripts for common FFmpeg tasks involving image and video processing.

## 📦 Scripts

All scripts are located in the `scripts/` folder.

### 🎞️ Video to GIF

**`vid2gif.bat`**
Converts a video file to a GIF.

```bash
Usage: vid2gif.bat input.mp4 output.gif
```

### 🖼️ Video to PNG

**`vid2png.bat`**
Extracts PNG frames from a video file.

```bash
Usage: vid2png.bat input.mp4
Output: PNG images saved in the current folder
```

### 🖼️ Video to JPEG

**`vid2jpeg.bat`**
Extracts JPEG frames from a video file.

```bash
Usage: vid2jpeg.bat input.mp4
Output: JPEG images saved in the current folder
```

### 🖼️ PNG to JPEG

**`png2jpeg.bat`**
Converts all `.png` images in the current directory to `.jpg` format.

```bash
Usage: png2jpeg.bat
```

### 🎥 Images to Video

**`img2vid.bat`**
Creates a video from sequential image files.

```bash
Usage: img2vid.bat framerate output.mp4
Assumes input images are named sequentially, e.g., img001.png
```

### 📽️ Video to Proxy

**`vid2proxy.bat`**
Creates a low-resolution proxy version of a video.

```bash
Usage: vid2proxy.bat input.mp4 output_proxy.mp4
```

---

## ⚙️ Requirements

* [FFmpeg](https://ffmpeg.org/) must be installed and available in your system PATH.


## 🤝 Contributions

Feel free to open issues or pull requests to improve the scripts or add new tools.
