#!/usr/bin/env python3
import subprocess
import threading
import os
import signal
import time
from pathlib import Path
from multiprocessing import Pool, cpu_count

# =====================================================
# SETTINGS
# PARALLEL PROCESSING: 4 videos at once
# =====================================================

BG_VIDEO = r"D:\xamp\htdocs\imgen\public_html\public_html\public\videos\background_video\bg_video_1767381490.mp4"
PNG_TEMPLATE = r"D:\xamp\htdocs\imgen\public_html\public_html\public\img\user_template\user_template_1765786735_693fc46f7dfc9.png"

WIDTH, HEIGHT = 1080, 1920
FPS = 25
FADE_TIME = 1.2

OUTPUT_DIR = Path("output/ffmpeg_fixed")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

TESTS = [
    ("wipe_in", "01_wipe.mp4"),
    ("fade_in", "02_fade.mp4"),
    ("slide_in", "03_slide.mp4"),
    ("zoom_in", "04_zoom.mp4"),
    ("bounce_in", "05_bounce.mp4"),
    ("flip_in", "06_flip.mp4"),
    ("blur_in", "07_blur.mp4"),
    ("spiral_in", "08_spiral.mp4"),
    ("corner_wipe", "09_corner.mp4"),
    ("curtain", "10_curtain.mp4"),
    ("none", "11_none.mp4"),
    ("bounce_drop", "12_drop.mp4"),
    ("bounce_slide", "13_slide_r.mp4"),
    ("flip_vertical", "14_flip_v.mp4"),
    ("flash_zoom", "15_flash.mp4"),
    ("elastic_scale", "16_elastic.mp4"),
    ("spin_reveal", "17_spin.mp4"),
]

# =====================================================
# GPU / CPU AUTO SELECT
# =====================================================

def nvenc_available():
    try:
        out = subprocess.check_output(
            ["ffmpeg", "-hide_banner", "-encoders"],
            stderr=subprocess.DEVNULL,
            text=True
        )
        return "h264_nvenc" in out
    except Exception:
        return False

ENCODER = "h264_nvenc" if nvenc_available() else "libx264"
print(f"[INFO] Encoder: {ENCODER}")

# =====================================================
# FILTERGRAPH FACTORY - FIXED SYNTAX
# =====================================================

def fg_filter(anim):
    t = FADE_TIME
    
    # 1️⃣ FADE IN - Opacity fade
    if anim == "fade_in":
        return f"[tpl]fade=t=in:st=0:d={t}:alpha=1[fg]"
    
    # 2️⃣ SLIDE IN - X position animation
    if anim == "slide_in":
        return f"[tpl]null[fg]"
    
    # 3️⃣ ZOOM IN - Scale animation
    if anim == "zoom_in":
        return f"[tpl]scale='iw*(1+0.5*(1-min(t,{t})/{t}))':'ih*(1+0.5*(1-min(t,{t})/{t}))':eval=frame[fg]"
    
    # 4️⃣ BOUNCE IN - Diagonal bounce (top-left → CENTER)
    # Zoom: 1.8x → 1.0x (ultra-slow smooth settle over 4.8s)
    if anim == "bounce_in":
        duration = t * 4  # 4.8s
        p = f"min(t,{duration})/{duration}"
        return f"[tpl]scale='iw*(1+0.8*pow(1-{p},1.6))':'ih*(1+0.8*pow(1-{p},1.6))':eval=frame[fg]"
    
    # 5️⃣ FLIP IN - Realistic Card Flip (6 Repetitions)
    # Spins 6 times (6 * 180 = 1080 degrees effective visual rotation)
    # Width scales 1->0->1 six times
    # hflip toggles every half-spin to simulate back of card
    if anim == "flip_in":
        p = f"min(t,{t})/{t}"
        # 6 full flips over the duration
        # Width logic: abs(cos(6 * PI * p)) -> scales 1->0->1 six times
        # hflip logic: sin(6 * PI * p) < 0 -> toggle when "back" is visible
        
        return (
            f"[tpl]scale="
            f"'iw*max(abs(cos(6*PI*{p})),0.02)':" # 6 full width cycles
            f"ih:eval=frame,"
            f"hflip=enable='lt(sin(6*PI*{p}),0)'" # Flip when sin is negative (back side)
            f"[fg]"
        )
    
    # 6️⃣ BLUR IN - Blur reduces
    if anim == "blur_in":
        return f"[tpl]gblur='sigma=12*(1-min(t,{t})/{t})'[fg]"
    
    # 7️⃣ SPIRAL IN - Zoom + rotate
    if anim == "spiral_in":
        return f"[tpl]scale='iw*(0.3+0.7*min(t,{t})/{t})':'ih*(0.3+0.7*min(t,{t})/{t})':eval=frame,rotate='PI*(1-min(t,{t})/{t})':c=none[fg]"
    
    # 8️⃣ WIPE IN - Reveal from left
    if anim == "wipe_in":
        return f"[tpl]crop='iw*min(t,{t})/{t}':ih:0:0[fg]"
    
    # 9️⃣ CORNER WIPE - Diagonal reveal
    if anim == "corner_wipe":
        return f"[tpl]crop='iw*min(t,{t})/{t}':'ih*min(t,{t})/{t}':0:0[fg]"
    
    # 🔟 CURTAIN - Center reveal
    if anim == "curtain":
        return f"[tpl]crop='iw*min(t,{t})/{t}':ih:'(iw-iw*min(t,{t})/{t})/2':0[fg]"
    
    # ⭕ NONE - Static overlay (baseline)
    if anim == "none":
        return "[tpl]null[fg]"

    # 1️⃣2️⃣ BOUNCE DROP - Drop from top with bounce
    if anim == "bounce_drop":
        # Similar to flip/bounce, use slow motion settle logic for scaling
        duration = t * 4
        p = f"min(t,{duration})/{duration}"
        return f"[tpl]scale='iw*(1+0.5*pow(1-{p},3))':'ih*(1+0.5*pow(1-{p},3))':eval=frame[fg]"

    # 1️⃣3️⃣ BOUNCE SLIDE RIGHT - Slide from right with bounce
    if anim == "bounce_slide":
        duration = t * 4
        p = f"min(t,{duration})/{duration}"
        return f"[tpl]scale='iw*(1+0.5*pow(1-{p},3))':'ih*(1+0.5*pow(1-{p},3))':eval=frame[fg]"

    # 1️⃣4️⃣ FLIP VERTICAL - Vertical card flip
    if anim == "flip_vertical":
        p = f"min(t,{t})/{t}"
        fp = f"min(max(({p}-0.5)/0.25,0),1)"
        return (
            f"[tpl]scale="
            f"iw:"
            f"'ih*max(pow(abs(1-2*{fp}),0.7),0.02)':eval=frame,"
            f"vflip=enable='gte({fp},0.5)'"
            f"[fg]"
        )

    # 1️⃣5️⃣ FLASH ZOOM - Flash brightness + Zoom
    if anim == "flash_zoom":
        return f"[tpl]scale='iw*(1+0.6*(1-min(t,{t})/{t}))':'ih*(1+0.6*(1-min(t,{t})/{t}))':eval=frame,eq=brightness='0.5*pow(1-min(t,{t})/{t},2)':saturation=1[fg]"

    # 1️⃣6️⃣ ELASTIC SCALE - Wobbly zoom center
    if anim == "elastic_scale":
        p = f"min(t,{t})/{t}"
        sp = f"max({p}-1.0,0)*0" # Dummy for now, real elastic in equation below
        # Elastic: 1 + 0.5 * pow(1-p,2) * cos(3*PI*p)
        return f"[tpl]scale='iw*(1+0.5*pow(1-{p},2)*cos(3*PI*{p}))':'ih*(1+0.5*pow(1-{p},2)*cos(3*PI*{p}))':eval=frame[fg]"

    # 1️⃣7️⃣ SPIN REVEAL - Rotate 360 + Scale overshoot
    if anim == "spin_reveal":
        p = f"min(t,{t})/{t}"
        return (
            f"[tpl]scale='iw*(0.1+0.9*{p})':'ih*(0.1+0.9*{p})':eval=frame,"
            f"rotate='2*PI*(1-pow({p},0.5))':c=none"
            f"[fg]"
        )
    
    raise ValueError(anim)

# =====================================================
# WATCHDOG
# =====================================================

def run(cmd, timeout=300):
    proc = subprocess.Popen(cmd, stderr=subprocess.PIPE, text=True)
    def killer():
        time.sleep(timeout)
        if proc.poll() is None:
            os.kill(proc.pid, signal.SIGKILL)
    threading.Thread(target=killer, daemon=True).start()
    _, stderr = proc.communicate()
    if proc.returncode != 0:
        print(f"❌ FFmpeg Error (last 300 chars):\n{stderr[-300:]}")
    return proc.returncode

# =====================================================
# RENDER
# =====================================================

def render(anim, outfile):
    out = OUTPUT_DIR / outfile
    print(f"[{anim}] Rendering...")

    fg = fg_filter(anim)

    # Special case for slide_in: custom overlay position
    if anim == "slide_in":
        filter_complex = (
            f"[0:v]scale={WIDTH}:{HEIGHT},setsar=1[bg];"
            f"[1:v]scale=-1:{HEIGHT},setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay='W*(1-min(t,{FADE_TIME})/{FADE_TIME})':'(H-h)/2':shortest=1"
        )
    # Special case for bounce_in: Diagonal bounce (top-left → CENTER)
    # Phase 1 (0-50%): Horizontal slide from left to center
    # Phase 2 (50-100%): Ultra-slow damped oscillation (0.25x speed)
    # Total Duration: 4x FADE_TIME (4.8s) for slow motion effect
    elif anim == "bounce_in":
        DURATION = FADE_TIME * 4  # 4.8s
        p = f"min(t,{DURATION})/{DURATION}"
        
        # Consistent damping for slow motion
        bounce_p = f"max({p}-0.5,0)/0.5"  # 0 to 1 during bounce phase
        
        filter_complex = (
            f"[0:v]scale={WIDTH}:{HEIGHT},setsar=1[bg];"
            f"[1:v]scale=-1:{HEIGHT},setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay="
            # X: LEFT → CENTER (stops and locks at 50% of extended duration)
            f"'if(lte({p},0.5),-{WIDTH}+2*{WIDTH}*{p},0)+(W-w)/2':"
            # Y: 6 bounces spread over the extended duration
            f"'if(lte({p},0.5),0,-350*pow(1-{bounce_p},0.4)*sin(6*PI*{bounce_p}))+(H-h)/2':shortest=1"
        )
    # Special case for bounce_drop: Drop from top with bounce
    elif anim == "bounce_drop":
        DURATION = FADE_TIME * 4
        p = f"min(t,{DURATION})/{DURATION}"
        bounce_p = f"max({p}-0.5,0)/0.5"
        filter_complex = (
            f"[0:v]scale={WIDTH}:{HEIGHT},setsar=1[bg];"
            f"[1:v]scale=-1:{HEIGHT},setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay="
            f"'(W-w)/2':" # Centered X
            f"'if(lte({p},0.5),-H+H*{p},0)+(H-h)/2" # Phase 1: Drop
            f"-350*pow(1-{bounce_p},0.4)*sin(6*PI*{bounce_p})':shortest=1" # Phase 2: Bounce
        )

    # Special case for bounce_slide: Slide from right with bounce
    elif anim == "bounce_slide":
        DURATION = FADE_TIME * 4
        p = f"min(t,{DURATION})/{DURATION}"
        bounce_p = f"max({p}-0.5,0)/0.5"
        filter_complex = (
            f"[0:v]scale={WIDTH}:{HEIGHT},setsar=1[bg];"
            f"[1:v]scale=-1:{HEIGHT},setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay="
            f"'if(lte({p},0.5),W-W*{p},0)+(W-w)/2" # Phase 1: Slide left
            f"+350*pow(1-{bounce_p},0.4)*sin(6*PI*{bounce_p})':" # Phase 2: Horizontal bounce
            f"'(H-h)/2':shortest=1" # Centered Y
        )
    
    else:
        filter_complex = (
            f"[0:v]scale={WIDTH}:{HEIGHT},setsar=1[bg];"
            f"[1:v]scale=-1:{HEIGHT},setsar=1[tpl];"
            f"{fg};"
            f"[bg][fg]overlay=(W-w)/2:(H-h)/2:shortest=1"
        )

    cmd = [
        "ffmpeg", "-y",
        "-i", BG_VIDEO,
        "-loop", "1", "-i", PNG_TEMPLATE,
        "-filter_complex", filter_complex,
        "-map", "0:a?",
        "-r", str(FPS),
        "-pix_fmt", "yuv420p",
        "-c:v", ENCODER,
        "-preset", "p5" if ENCODER == "h264_nvenc" else "medium",
        "-cq", "19" if ENCODER == "h264_nvenc" else None,
        "-b:v", "0" if ENCODER == "h264_nvenc" else None,
        str(out)
    ]

    cmd = [c for c in cmd if c is not None]
    start = time.time()
    returncode = run(cmd)
    elapsed = time.time() - start
    
    if returncode == 0:
        print(f"✅ [{anim}] Done in {elapsed:.2f}s")
    else:
        print(f"❌ [{anim}] FAILED")

# =====================================================
# RENDER WRAPPER FOR MULTIPROCESSING
# =====================================================

def render_wrapper(args):
    """Wrapper function for multiprocessing"""
    anim, outfile = args
    render(anim, outfile)
    return (anim, outfile)

# =====================================================
# MAIN
# =====================================================

if __name__ == "__main__":
    print("="*70)
    print(" "*15 + "FFMPEG PARALLEL ANIMATION RENDERER")
    print("="*70)
    print(f"Encoder: {ENCODER}")
    print(f"Total animations: {len(TESTS)}")
    print(f"Parallel workers: 4")
    print("="*70)
    
    start_time = time.time()
    
    # Process 4 videos at a time using multiprocessing
    with Pool(processes=4) as pool:
        results = pool.map(render_wrapper, TESTS)
    
    total_time = time.time() - start_time
    
    print("\n" + "="*70)
    print(" "*25 + "SUMMARY")
    print("="*70)
    print(f"Total videos: {len(TESTS)}")
    print(f"Total time: {total_time:.2f}s ({total_time/60:.2f} min)")
    print(f"Average per video: {total_time/len(TESTS):.2f}s")
    print(f"Throughput: {len(TESTS)/total_time:.2f} videos/sec")
    print("="*70)
    print("\n✅ All renders completed")
    print(f"Output directory: {OUTPUT_DIR}")

