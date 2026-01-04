#!/usr/bin/env python
"""
Complete Animation Library
11 different overlay animations optimized for GPU encoding
"""

import subprocess
import sys
from pathlib import Path

# Fix Windows console encoding
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')

FFMPEG = "ffmpeg"

# =========================
# INPUT FILES
# =========================
BG_VIDEO = r"D:\xamp\htdocs\imgen\public_html\public_html\public\videos\background_video\bg_video_1767381490.mp4"
PNG_TEMPLATE = r"D:\xamp\htdocs\imgen\public_html\public_html\public\img\user_template\user_template_1765786735_693fc46f7dfc9.png"

# =========================
# OUTPUT PATHS
# =========================
OUTPUT_DIR = Path("output")
OUTPUT_DIR.mkdir(exist_ok=True)
FINAL_OUTPUT = OUTPUT_DIR / "animated_video.mp4"

# =========================
# SETTINGS
# =========================
WIDTH, HEIGHT = 1080, 1920
ANIM_DURATION = 1.5  # Animation duration in seconds
FPS = 25

# 🎬 Animation type (CHANGE THIS)
ANIMATION = "wipe_in"

# Available animations:
# wipe_in | fade_in | slide_in | zoom_in | bounce_in | 
# flip_in | blur_in | spiral_in | corner_wipe | curtain | none


def get_animation_filter(animation):
    """
    Returns (overlay_prep, overlay_expr) tuple
    overlay_prep: Filter to prepare the overlay
    overlay_expr: Custom overlay expression (None for standard overlay)
    """
    
    if animation == "wipe_in":
        # Left to right wipe reveal
        return (
            f"[1:v]scale={WIDTH}:{HEIGHT},"
            f"format=rgba[ov]"
        ), f"overlay=x='if(lt(t\\,{ANIM_DURATION})\\,W-(W*t/{ANIM_DURATION})\\,0)':y=0:format=auto"
    
    elif animation == "fade_in":
        # Gradual opacity fade
        return (
            f"[1:v]scale={WIDTH}:{HEIGHT},"
            f"fade=t=in:st=0:d={ANIM_DURATION}:alpha=1[ov]"
        ), None
    
    elif animation == "slide_in":
        # Slide from left
        return (
            f"[1:v]scale={WIDTH}:{HEIGHT},"
            f"format=rgba[ov]"
        ), f"overlay=x='if(lt(t\\,{ANIM_DURATION})\\,-W+(W*t/{ANIM_DURATION})\\,0)':y=0:format=auto"
    
    elif animation == "zoom_in":
        # Scale up with zoom
        zoom_frames = int(ANIM_DURATION * FPS)
        return (
            f"[1:v]scale={WIDTH*2}:{HEIGHT*2},"
            f"zoompan=z='min(zoom+0.01,1.5)':d={zoom_frames}:s={WIDTH}x{HEIGHT},"
            f"fade=t=in:st=0:d={ANIM_DURATION}:alpha=1[ov]"
        ), None
    
    elif animation == "bounce_in":
        # Elastic bounce effect (simulated with position)
        return (
            f"[1:v]scale={WIDTH}:{HEIGHT},"
            f"format=rgba[ov]"
        ), f"overlay=x=0:y='if(lt(t\\,{ANIM_DURATION})\\,H*sin((1-t/{ANIM_DURATION})*3.14159)\\,0)':format=auto"
    
    elif animation == "flip_in":
        # 3D flip effect (horizontal flip with fade)
        return (
            f"[1:v]scale={WIDTH}:{HEIGHT},"
            f"hflip,"  # Flip horizontally
            f"fade=t=in:st=0:d={ANIM_DURATION}:alpha=1[ov]"
        ), None
    
    elif animation == "blur_in":
        # Blur to sharp focus
        blur_amount = 20
        return (
            f"[1:v]scale={WIDTH}:{HEIGHT},"
            f"boxblur=luma_radius='if(lt(t\\,{ANIM_DURATION})\\,{blur_amount}*(1-t/{ANIM_DURATION})\\,0)':luma_power=1,"
            f"fade=t=in:st=0:d={ANIM_DURATION}:alpha=1[ov]"
        ), None
    
    elif animation == "spiral_in":
        # Spin and zoom combined
        zoom_frames = int(ANIM_DURATION * FPS)
        return (
            f"[1:v]scale={WIDTH*1.5}:{HEIGHT*1.5},"
            f"rotate='if(lt(t\\,{ANIM_DURATION})\\,2*PI*(1-t/{ANIM_DURATION})\\,0)':c=none:ow={WIDTH}:oh={HEIGHT},"
            f"fade=t=in:st=0:d={ANIM_DURATION}:alpha=1[ov]"
        ), None
    
    elif animation == "corner_wipe":
        # Diagonal wipe from top-left corner
        return (
            f"[1:v]scale={WIDTH}:{HEIGHT},"
            f"format=rgba[ov]"
        ), f"overlay=x='if(lt(t\\,{ANIM_DURATION})\\,-W+(W*t/{ANIM_DURATION})\\,0)':y='if(lt(t\\,{ANIM_DURATION})\\,-H+(H*t/{ANIM_DURATION})\\,0)':format=auto"
    
    elif animation == "curtain":
        # Open from center (split reveal)
        return (
            f"[1:v]scale={WIDTH}:{HEIGHT},"
            f"split[left][right];"
            f"[left]crop=iw/2:ih:0:0[l];"
            f"[right]crop=iw/2:ih:iw/2:0[r];"
            f"[l][r]hstack[ov]"
        ), f"overlay=x='if(lt(t\\,{ANIM_DURATION})\\,W/2*(1-t/{ANIM_DURATION})\\,0)':y=0:format=auto"
    
    elif animation == "none":
        # Instant overlay (no animation)
        return (
            f"[1:v]scale={WIDTH}:{HEIGHT}[ov]"
        ), None
    
    else:
        raise ValueError(f"Unknown animation: {animation}")


def run(cmd, step):
    print(f"\n▶ {step}")
    proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if proc.returncode != 0:
        print("❌ FFmpeg failed")
        print(proc.stderr)
        sys.exit(1)
    print("✅ Success")


# =========================================================
# MAIN PIPELINE
# =========================================================
print("\n" + "="*60)
print("VIDEO GENERATION WITH ANIMATION")
print("="*60)
print(f"Animation: {ANIMATION}")
print(f"Duration: {ANIM_DURATION}s")
print("="*60)

# Build filter complex based on animation type
overlay_prep, overlay_expr = get_animation_filter(ANIMATION)

if overlay_expr:
    # Custom overlay expression (wipe, slide, bounce, corner, curtain)
    filter_complex = (
        f"[0:v]scale={WIDTH}:{HEIGHT}:force_original_aspect_ratio=decrease,"
        f"pad={WIDTH}:{HEIGHT}:(ow-iw)/2:(oh-ih)/2[bg];"
        f"{overlay_prep};"
        f"[bg][ov]{overlay_expr}"
    )
else:
    # Standard overlay (fade, zoom, flip, blur, spiral, none)
    filter_complex = (
        f"[0:v]scale={WIDTH}:{HEIGHT}:force_original_aspect_ratio=decrease,"
        f"pad={WIDTH}:{HEIGHT}:(ow-iw)/2:(oh-ih)/2[bg];"
        f"{overlay_prep};"
        f"[bg][ov]overlay=0:0:format=auto"
    )

run([
    FFMPEG, "-y",
    "-i", BG_VIDEO,
    "-loop", "1",
    "-i", PNG_TEMPLATE,
    "-filter_complex", filter_complex,
    "-c:v", "h264_nvenc",
    "-preset", "p4",
    "-profile:v", "high",
    "-pix_fmt", "yuv420p",
    "-b:v", "6M",
    "-maxrate:v", "9M",
    "-movflags", "+faststart",
    "-c:a", "aac",
    "-b:a", "192k",
    "-shortest",
    str(FINAL_OUTPUT)
], "Generating video")

print("\n" + "="*60)
print("✅ ALL DONE")
print(f"Output: {FINAL_OUTPUT}")
print(f"Size: {FINAL_OUTPUT.stat().st_size / (1024*1024):.1f} MB")
print("="*60)
