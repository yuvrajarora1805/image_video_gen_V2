#!/usr/bin/env python
"""
Video Generator Script (Single Video) - FFmpeg Native Version
Processes a single video with animation using direct FFmpeg commands.
Refactored to remove MoviePy dependency for better stability and performance.
"""

import sys
import os
import subprocess
import json
import time

# Get FFmpeg binary from environment (set by PHP job) or default to 'ffmpeg'
FFMPEG_BIN = os.environ.get('IMAGEIO_FFMPEG_EXE', 'ffmpeg')
# Assume ffprobe is in the same location or path
if os.path.dirname(FFMPEG_BIN):
    FFPROBE_BIN = os.path.join(os.path.dirname(FFMPEG_BIN), 'ffprobe')
else:
    FFPROBE_BIN = 'ffprobe'

def get_video_dims(video_path):
    """Get video dimensions using ffprobe"""
    cmd = [
        FFPROBE_BIN, '-v', 'quiet', 
        '-print_format', 'json',
        '-show_streams', 
        '-select_streams', 'v:0',
        video_path
    ]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            data = json.loads(result.stdout)
            if 'streams' in data and len(data['streams']) > 0:
                return int(data['streams'][0]['width']), int(data['streams'][0]['height'])
    except Exception as e:
        print(f"Warning: Could not get video info via ffprobe: {e}")
    
    # Fallback default if probe fails (though this usually means ffmpeg will fail too)
    return 1080, 1920

def detect_gpu_encoder():
    """Detect available GPU encoder for hardware acceleration"""
    use_gpu = os.environ.get('USE_GPU', '1')
    if use_gpu != '1':
        print("GPU acceleration disabled via configuration")
        return None, None
    
    force_nvenc = os.environ.get('FORCE_NVENC', '0')
    
    # Default params for NVENC
    nvenc_params = ['-c:v', 'h264_nvenc', '-rc', 'vbr', '-cq', '23', '-b:v', '5M', '-maxrate', '10M', '-preset', 'p1']
    
    if force_nvenc == '1':
        return 'h264_nvenc', nvenc_params

    # Simple check for NVENC availability
    try:
        list_result = subprocess.run([FFMPEG_BIN, '-hide_banner', '-encoders'], capture_output=True, text=True, timeout=5)
        if 'h264_nvenc' in list_result.stdout:
            return 'h264_nvenc', nvenc_params
    except Exception:
        pass
        
    return None, None

def get_animation_filter(animation, width, height):
    """
    Returns (overlay_prep, overlay_expr) tuple based on animation type.
    """
    
    # Default durations
    duration = 2.0
    
    if animation == "wipe-in" or animation == "wipe_in":
        duration = 2.0
        return (
            f"[1:v]scale={width}:{height},"
            f"format=rgba[ov]"
        ), f"overlay=x='if(lt(t\\,{duration})\\,W-(W*t/{duration})\\,0)':y=0:format=auto"
    
    elif animation == "fade-in" or animation == "fade_in":
        duration = 3.0
        return (
            f"[1:v]scale={width}:{height},"
            f"fade=t=in:st=0:d={duration}:alpha=1[ov]"
        ), f"overlay=0:0:format=auto"
    
    elif animation == "slide-in" or animation == "slide_in":
        duration = 4.0
        return (
            f"[1:v]scale={width}:{height},"
            f"format=rgba[ov]"
        ), f"overlay=x='if(lt(t\\,{duration})\\,-W+(W*t/{duration})\\,0)':y=0:format=auto"
    
    elif animation == "zoom-in" or animation == "zoom_in":
        duration = 3.5
        fps = 25
        zoom_frames = int(duration * fps)
        return (
            f"[1:v]scale={width*2}:{height*2},"
            f"zoompan=z='max(1.0,1.5-0.01*on)':d={zoom_frames}:s={width}x{height},"
            f"fade=t=in:st=0:d={duration}:alpha=1[ov]"
        ), f"overlay=0:0:format=auto"
    
    elif animation == "bounce-in" or animation == "bounce_in":
        duration = 3.5
        # y(t) = damped cosine bounce
        # starts above frame (-H), settles at y=0
        return (
            f"[1:v]scale={width}:{height},format=rgba[ov]"
        ), f"overlay=x=0:y='if(lt(t\\,{duration})\\,-H*exp(-2*t)*cos(6*t)\\,0)':format=auto"
    
    elif animation == "spiral-in" or animation == "spiral_in" or animation == "spin-reveal":
        duration = 4.0
        return (
            f"[1:v]"
            f"rotate='if(lt(t\\,{duration})\\,2*PI*(1-t/{duration})\\,0)':"
            f"c=none,"
            f"scale={width}:{height},"
            f"fade=t=in:st=0:d={duration}:alpha=1[ov]"
        ), f"overlay=0:0:format=auto"

    elif animation == "flip-in" or animation == "flip_in":
        duration = 2.0
        # Horizontal flip effect using scale
        return (
            f"[1:v]scale={width}:{height},"
            f"format=rgba[ov]"
        ), f"overlay=x='if(lt(t\\,{duration})\\,W/2-W/2*abs(cos(PI*t/{duration}))\\,0)':y=0:format=auto"

    elif animation == "flip-vertical" or animation == "flip_vertical":
        duration = 2.0
        # Vertical flip effect
        return (
            f"[1:v]scale={width}:{height},"
            f"format=rgba[ov]"
        ), f"overlay=x=0:y='if(lt(t\\,{duration})\\,H/2-H/2*abs(cos(PI*t/{duration}))\\,0)':format=auto"

    elif animation == "bounce-drop" or animation == "bounce_drop":
        duration = 3.5
        # Fall from top (y: -H to 0) with bounce
        return (
            f"[1:v]scale={width}:{height},format=rgba[ov]"
        ), f"overlay=x=0:y='if(lt(t\\,{duration})\\,H*exp(-2*t)*cos(6*t)-H\\,0)':format=auto"

    elif animation == "bounce-slide" or animation == "bounce_slide":
        duration = 3.5
        # Slide from left (x: -W to 0) with bounce
        return (
            f"[1:v]scale={width}:{height},format=rgba[ov]"
        ), f"overlay=x='if(lt(t\\,{duration})\\,-W*exp(-2*t)*cos(6*t)\\,0)':y=0:format=auto"

    elif animation == "elastic-scale" or animation == "elastic_scale":
        duration = 3.5
        # Scale 0 -> 1.2 -> 1.0
        zoom_frames = int(duration * 25)
        return (
            f"[1:v]scale={width*2}:{height*2},"
            f"zoompan=z='if(lt(on,{zoom_frames}),min(zoom+0.05,1.2)-0.005*on,1.0)':d={zoom_frames}:s={width}x{height},"
            f"fade=t=in:st=0:d={duration}:alpha=1[ov]"
        ), f"overlay=0:0:format=auto"
        
    elif animation == "none":
        return (
            f"[1:v]scale={width}:{height}[ov]"
        ), f"overlay=0:0:format=auto"
    
    else:
        # Default to wipe-in
        print(f"Warning: Unknown animation '{animation}', defaulting to wipe-in")
        duration = 2.0
        return (
            f"[1:v]scale={width}:{height},"
            f"format=rgba[ov]"
        ), f"overlay=x='if(lt(t\\,{duration})\\,W-(W*t/{duration})\\,0)':y=0:format=auto"

def main():
    # 1. Parse Arguments
    if len(sys.argv) < 4:
        print("Usage: python video_generator.py <bg_video> <template> <output> <animation_type>")
        sys.exit(1)
        
    bg_video_path = sys.argv[1]
    template_path = sys.argv[2]
    output_path = sys.argv[3]
    animation_type = sys.argv[4] if len(sys.argv) > 4 else 'wipe-in'
    
    print(f"Processing: {output_path}")
    print(f"Animation: {animation_type}")
    print(f"Using FFmpeg binary: {FFMPEG_BIN}")

    # 2. Validation
    if not os.path.exists(bg_video_path):
        print(f"Error: BG video not found {bg_video_path}")
        sys.exit(1)
    if not os.path.exists(template_path):
        print(f"Error: Template not found {template_path}")
        sys.exit(1)
        
    # 3. Detect HW Accel
    gpu_codec, gpu_params = detect_gpu_encoder()
    
    # 4. Get Video Info
    width, height = get_video_dims(bg_video_path)
    
    # 5. Build Filter Complex
    overlay_prep, overlay_expr = get_animation_filter(animation_type, width, height)
    
    filter_complex = (
        f"[0:v]scale={width}:{height}:force_original_aspect_ratio=decrease,"
        f"pad={width}:{height}:(ow-iw)/2:(oh-ih)/2[bg];"
        f"{overlay_prep};"
        f"[bg][ov]{overlay_expr}"
    )
    
    # 6. Construct Command
    cmd = [FFMPEG_BIN, '-y']
    
    # Input 0: Background Video
    cmd.extend(['-i', bg_video_path])
    
    # Input 1: Template Image (Loop)
    cmd.extend(['-loop', '1', '-i', template_path])
    
    # Filter
    cmd.extend(['-filter_complex', filter_complex])
    
    # Encoding Options
    if gpu_codec:
        print(f"Using GPU Encoding: {gpu_codec}")
        cmd.extend(gpu_params)
    else:
        print("Using CPU Encoding")
        cmd.extend(['-c:v', 'libx264', '-preset', 'ultrafast', '-crf', '23'])
        
    # Common Options
    cmd.extend([
        '-pix_fmt', 'yuv420p',
        '-c:a', 'aac',    # Copy audio from bg video (implicitly mapped from 0 unless specified)
        '-map', '0:a?',   # Map audio from input 0 if it exists
        '-shortest',      # Stop when the shortest input (bg video) ends
        output_path
    ])
    
    # 7. Execute
    print(f"Executing FFmpeg...")
    start_time = time.time()
    
    try:
        # Use subprocess.run to execute
        process = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        if process.returncode != 0:
            print("Error: FFmpeg execution failed")
            print(process.stderr)
            sys.exit(1)
            
        elapsed = time.time() - start_time
        print(f"SUCCESS: Video generated at {output_path}")
        print(f"Time taken: {elapsed:.2f}s")
        
    except Exception as e:
        print(f"Error executing ffmpeg: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
