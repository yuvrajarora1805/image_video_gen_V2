import yt_dlp
import os

# Create download folder
os.makedirs("downloads", exist_ok=True)

URLS = [
    "https://www.youtube.com/live/i3BYGL0tFhA",
        "https://youtu.be/jwdZVRAOXTU",
            "https://www.youtube.com/live/9w0cVAso01E",
                "https://youtu.be/8ZyLisztAOo",
                    "https://youtu.be/WjGI1OWYDKI"
                    ]
ydl_opts = {
                        "format": "bestvideo+bestaudio/best",
                            "outtmpl": "downloads/%(title)s.%(ext)s",
                                "merge_output_format": "mp4",
                                    "noplaylist": True,
                                    }
with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                                        ydl.download(URLS)
