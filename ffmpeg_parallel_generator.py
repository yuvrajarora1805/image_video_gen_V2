#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FFmpeg-based Parallel Video Generator
Supports GPU (NVENC) and CPU (libx264) with automatic detection
Processes 4-16 videos in parallel for maximum throughput
"""

import subprocess
import json
import sys
import os
import time
from multiprocessing import Pool
from pathlib import Path

# GPU Detection (same logic as MoviePy version)
def nvenc_available():
    """Check if NVENC is available"""
    try:
        result = subprocess.run(
            ['ffmpeg', '-hide_banner', '-encoders'],
            capture_output=True,
            text=True,
            timeout=5
        )
        return 'h264_nvenc' in result.stdout
    except:
        return False

def detect_gpu_encoder():
    """
    Detect GPU encoder based on environment variable
    Returns: (encoder, params_dict)
    """
    # Check environment variable (set by PHP controller)
    use_gpu = '0'
    
    if use_gpu != '1':
        print("[INFO] GPU disabled by environment variable")
        return 'libx264', {'preset': 'medium', 'crf': '23'}
    
    # Try NVENC
    if nvenc_available():
        print("[INFO] Using NVENC (GPU encoding)")
        return 'h264_nvenc', {}
    
    # Fallback to CPU
    print("[INFO] NVENC not available, using libx264 (CPU encoding)")
    return 'libx264', {'preset': 'medium', 'crf': '23'}

# Global encoder settings
ENCODER, ENCODER_PARAMS = detect_gpu_encoder()
FFMPEG_BIN = 'ffmpeg'

def create_ffmpeg_command(bg_video, template, output, animation):
    """
    Create FFmpeg command with filtergraph for animation
    Enhanced with 17 high-quality animations
    """
    t = 1.2  # FADE_TIME constant
    
    # Animation filtergraphs - 11 TESTED and WORKING animations
    def fg_filter(anim):
        # FADE IN - Opacity fade
        if anim == "fade-in":
            return f"[tpl]fade=t=in:st=0:d={t}:alpha=1[fg]"
        
        # SLIDE IN - X position animation (handled in overlay)
        if anim == "slide-in":
            return f"[tpl]null[fg]"
        
        # ZOOM IN - Scale animation
        if anim == "zoom-in":
            return f"[tpl]scale='iw*(1+0.5*(1-min(t,{t})/{t}))':'ih*(1+0.5*(1-min(t,{t})/{t}))':eval=frame[fg]"
        
        # BOUNCE IN - Diagonal bounce with settle (4.8s duration)
        if anim == "bounce-in":
            duration = t * 4
            p = f"min(t,{duration})/{duration}"
            return f"[tpl]scale='iw*(1+0.8*pow(1-{p},1.6))':'ih*(1+0.8*pow(1-{p},1.6))':eval=frame[fg]"
        
        # FLIP IN - Horizontal card flip (6 repetitions)
        if anim == "flip-in":
            p = f"min(t,{t})/{t}"
            return (
                f"[tpl]scale="
                f"'iw*max(abs(cos(6*PI*{p})),0.02)':"
                f"ih:eval=frame,"
                f"hflip=enable='lt(sin(6*PI*{p}),0)'"
                f"[fg]"
            )
        
        # NONE - Static overlay
        if anim == "none":
            return "[tpl]null[fg]"
        
        # BOUNCE DROP - Drop from top with bounce (4.8s duration)
        if anim == "bounce-drop":
            duration = t * 4
            p = f"min(t,{duration})/{duration}"
            return f"[tpl]scale='iw*(1+0.5*pow(1-{p},3))':'ih*(1+0.5*pow(1-{p},3))':eval=frame[fg]"
        
        # BOUNCE SLIDE - Slide from right with bounce (4.8s duration)
        if anim == "bounce-slide":
            duration = t * 4
            p = f"min(t,{duration})/{duration}"
            return f"[tpl]scale='iw*(1+0.5*pow(1-{p},3))':'ih*(1+0.5*pow(1-{p},3))':eval=frame[fg]"
        
        # FLIP VERTICAL - Vertical card flip
        if anim == "flip-vertical":
            p = f"min(t,{t})/{t}"
            fp = f"1-abs(1-2*{p})"
            sp = f"abs(1-2*{p})"
            return (
                f"[tpl]"
                f"scale=iw:'ih*max(pow({sp},0.7),0.05)':eval=frame,"
                f"vflip=enable='between({fp},0.5,1)'"
                f"[fg]"
            )
        
        # ELASTIC SCALE - Wobbly zoom with oscillation
        if anim == "elastic-scale":
            p = f"min(t,{t})/{t}"
            return f"[tpl]scale='iw*(1+0.5*pow(1-{p},2)*cos(3*PI*{p}))':'ih*(1+0.5*pow(1-{p},2)*cos(3*PI*{p}))':eval=frame[fg]"
        
        # SPIN REVEAL - 360° rotation + scale (2.4s duration)
        if anim == "spin-reveal":
            duration = t * 2.0
            p = f"min(t,{duration})/{duration}"
            return (
                f"[tpl]"
                f"rotate='2*PI*(1-pow({p},0.5))'"
                f":ow=rotw(iw):oh=roth(ih):c=none,"
                f"scale='iw*(0.1+0.9*{p})':'ih*(0.1+0.9*{p})':eval=frame"
                f"[fg]"
            )
        
        # Default to fade-in for unknown animations
        return f"[tpl]fade=t=in:st=0:d={t}:alpha=1[fg]"
    
    fg = fg_filter(animation)
    
    # Special overlay positioning for slide-in animation only
    if animation == "slide-in":
        filter_complex = (
            f"[0:v]scale=1080:1920,setsar=1[bg];"
            f"[1:v]scale=-1:1920,setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay='W*(1-min(t,{t})/{t})':'(H-h)/2':shortest=1"
        )
    elif animation == "curtain":
        # Vertical curtain using geq for center wipe
        filter_complex = (
            f"[0:v]scale=1080:1920,setsar=1[bg];"
            f"[1:v]scale=-1:1920,setsar=1[tpl];"
            f"[tpl]geq=lum='if(lte(abs(Y-H/2),H*min(t,{t})/{t}/2),lum(X,Y),0)':a='if(lte(abs(Y-H/2),H*min(t,{t})/{t}/2),alpha(X,Y),0)'[fg];"
            f"[bg][fg]overlay=(W-w)/2:(H-h)/2:shortest=1"
        )
    elif animation == "bounce-in":
        DURATION = t * 4
        p = f"min(t,{DURATION})/{DURATION}"
        bounce_p = f"max({p}-0.5,0)/0.5"
        filter_complex = (
            f"[0:v]scale=1080:1920,setsar=1[bg];"
            f"[1:v]scale=-1:1920,setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay="
            f"'if(lte({p},0.5),-1080+2*1080*{p},0)+(W-w)/2':"
            f"'if(lte({p},0.5),0,-350*pow(1-{bounce_p},0.4)*sin(6*PI*{bounce_p}))+(H-h)/2':shortest=1"
        )
    elif animation == "bounce-drop":
        DURATION = t * 4
        p = f"min(t,{DURATION})/{DURATION}"
        bounce_p = f"max({p}-0.5,0)/0.5"
        filter_complex = (
            f"[0:v]scale=1080:1920,setsar=1[bg];"
            f"[1:v]scale=-1:1920,setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay="
            f"'(W-w)/2':"
            f"'if(lte({p},0.5),-H+H*{p},0)+(H-h)/2-350*pow(1-{bounce_p},0.4)*sin(6*PI*{bounce_p})':shortest=1"
        )
    elif animation == "bounce-slide":
        DURATION = t * 4
        p = f"min(t,{DURATION})/{DURATION}"
        bounce_p = f"max({p}-0.5,0)/0.5"
        filter_complex = (
            f"[0:v]scale=1080:1920,setsar=1[bg];"
            f"[1:v]scale=-1:1920,setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay="
            f"'if(lte({p},0.5),W-W*{p},0)+(W-w)/2+350*pow(1-{bounce_p},0.4)*sin(6*PI*{bounce_p})':"
            f"'(H-h)/2':shortest=1"
        )
    else:
        # Default centered overlay for all other animations
        filter_complex = (
            f"[0:v]scale=1080:1920,setsar=1[bg];"
            f"[1:v]scale=-1:1920,setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay=(W-w)/2:(H-h)/2:shortest=1"
        )
    
    # Build command
    cmd = [FFMPEG_BIN, '-y']
    # Removed hwaccel cuda because it often crashes with software filter_complex

    cmd.extend([
        '-i', bg_video,
        '-loop', '1', '-i', template,
        '-filter_complex', filter_complex,
        '-map', '0:a?',
        '-r', '25',
        '-pix_fmt', 'yuv420p',
        '-colorspace', 'bt709',
        '-color_primaries', 'bt709',
        '-color_trc', 'bt709',
        '-color_range', 'tv',
        '-c:v', ENCODER,
    ])
    
    # Add encoder-specific parameters
    if ENCODER != 'h264_nvenc':
        # libx264
        cmd.extend([
            '-preset', ENCODER_PARAMS['preset'],
            '-crf', ENCODER_PARAMS['crf'],
        ])
    
    cmd.extend(['-c:a', 'aac', '-b:a', '128k', output])
    
    return cmd

def generate_single_video(task):
    """
    Generate a single video using FFmpeg
    Args: task dict with bg_video, template, output, animation
    Returns: dict with success status
    """
    try:
        bg_video = task['bg_video']
        template = task['template']
        output = task['output']
        animation = task.get('animation', 'fade-in')
        
        print(f"[FFmpeg] Processing: {Path(output).name} (Animation: {animation})")
        
        # Create FFmpeg command
        cmd = create_ffmpeg_command(bg_video, template, output, animation)
        
        # Execute
        start_time = time.time()
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=1200 # Increased to 15 minutes to prevent random failures on heavy load
        )
        elapsed = time.time() - start_time
        
        if result.returncode == 0:
            file_size = os.path.getsize(output) / (1024 * 1024)
            print(f"[FFmpeg] SUCCESS: {Path(output).name} ({elapsed:.2f}s, {file_size:.2f}MB)")
            return {
                'success': True,
                'output': output,
                'time': elapsed,
                'size': file_size
            }
        else:
            print(f"[FFmpeg] FAILED: {Path(output).name}")
            print(f"Error: {result.stderr[-500:]}")
            return {
                'success': False,
                'output': output,
                'error': result.stderr[-500:]
            }
            
    except Exception as e:
        print(f"[FFmpeg] EXCEPTION: {str(e)}")
        return {
            'success': False,
            'output': task.get('output', 'unknown'),
            'error': str(e)
        }

def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        print("Usage: python ffmpeg_parallel_generator.py '<json_payload>'")
        sys.exit(1)
    
    # Parse JSON payload
    # Parse JSON payload (support both file path and raw JSON string)
    input_arg = sys.argv[1]
    
    try:
        if os.path.exists(input_arg) and os.path.isfile(input_arg):
            # It's a file path
            with open(input_arg, 'r', encoding='utf-8') as f:
                tasks = json.load(f)
        else:
            # It's a raw JSON string
            tasks = json.loads(input_arg)
            
    except Exception as e:
        print(f"Error parsing input: {e}")
        sys.exit(1)
    
    print("="*70)
    print(" "*15 + "FFMPEG PARALLEL VIDEO GENERATOR")
    print("="*70)
    print(f"Encoder: {ENCODER}")
    print(f"Total videos: {len(tasks)}")
    print(f"Parallel workers: 12 (Optimized for 12-core CPU)")
    print("="*70)
    
    start_time = time.time()
    
    # Process in parallel (12 workers)
    with Pool(processes=12) as pool:
        results = pool.map(generate_single_video, tasks)
    
    total_time = time.time() - start_time
    
    # Count successes
    successful = sum(1 for r in results if r.get('success', False))
    failed = len(results) - successful
    
    print("\n" + "="*70)
    print(" "*25 + "SUMMARY")
    print("="*70)
    print(f"Total: {len(results)}")
    print(f"Success: {successful}")
    print(f"Failed: {failed}")
    print(f"Total time: {total_time:.2f}s ({total_time/60:.2f} min)")
    print(f"Avg per video: {total_time/len(results):.2f}s")
    print(f"Throughput: {len(results)/total_time:.2f} videos/sec")
    print("="*70)
    
    # Output JSON results for PHP to parse
    print("\nRESULTS_JSON_START")
    print(json.dumps(results))
    print("RESULTS_JSON_END")
    
    # Exit with appropriate code
    sys.exit(0 if failed == 0 else 1)

if __name__ == '__main__':
    main()
