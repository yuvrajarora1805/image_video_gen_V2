#!/usr/bin/env python
"""
Video Generator Script
Combines a background video with a template overlay using various animation effects
Supports: wipe-in, fade-in, slide-in, zoom-in, and none
"""

import sys
import os
import subprocess
import json
from moviepy.editor import *
import numpy as np
from PIL import Image

def get_gpu_status():
    """
    Get detailed GPU status information
    Returns dict with GPU availability, encoder type, and configuration status
    
    This function actually tests if the encoder works, not just if it's listed
    """
    status = {
        'available': False,
        'encoder': None,
        'enabled': False,
        'message': ''
    }
    
    # Check if GPU is enabled in configuration
    use_gpu = os.environ.get('USE_GPU', '1')
    status['enabled'] = (use_gpu == '1')
    
    if not status['enabled']:
        status['message'] = 'GPU acceleration disabled in configuration'
        return status
    
    # Check for available GPU encoders
    gpu_encoders = {
        'h264_nvenc': 'NVIDIA GPU',
        'h264_amf': 'AMD GPU',
        'h264_qsv': 'Intel Quick Sync'
    }
    
    for encoder, gpu_type in gpu_encoders.items():
        try:
            # First check if encoder is listed
            list_result = subprocess.run(
                ['ffmpeg', '-hide_banner', '-encoders'],
                capture_output=True,
                text=True,
                timeout=5
            )
            
            if encoder not in list_result.stdout:
                continue
            
            # Now actually test if the encoder works by doing a test encode
            test_result = subprocess.run(
                [
                    'ffmpeg',
                    '-f', 'lavfi',
                    '-i', 'nullsrc=s=256x256:d=0.1',  # Tiny test video
                    '-c:v', encoder,
                    '-f', 'null',
                    '-'
                ],
                capture_output=True,
                text=True,
                timeout=10
            )
            
            # If the test encode succeeded, this encoder works!
            if test_result.returncode == 0:
                status['available'] = True
                status['encoder'] = encoder
                status['message'] = f'{gpu_type} ({encoder}) verified and working'
                return status
                
        except subprocess.TimeoutExpired:
            continue
        except Exception as e:
            continue
    
    status['message'] = 'No working GPU encoder detected'
    return status

def detect_gpu_encoder():
    """
    Detect available GPU encoder for hardware acceleration
    Returns codec name or None if no GPU encoder available or disabled
    
    This function actually tests if the encoder works, not just if it's listed
    """
    # Check if GPU acceleration is enabled via environment variable
    use_gpu = os.environ.get('USE_GPU', '1')
    if use_gpu != '1':
        print("GPU acceleration disabled via configuration")
        return None
    
    gpu_encoders = [
        'h264_nvenc',    # NVIDIA GPU only
        # 'h264_amf',      # AMD GPU - disabled  
        'h264_qsv',      # Intel Quick Sync
    ]
    
    for encoder in gpu_encoders:
        try:
            # First check if encoder is listed
            list_result = subprocess.run(
                ['ffmpeg', '-hide_banner', '-encoders'],
                capture_output=True,
                text=True,
                timeout=5
            )
            
            if encoder not in list_result.stdout:
                continue
            
            # Now actually test if the encoder works by doing a test encode
            test_result = subprocess.run(
                [
                    'ffmpeg',
                    '-f', 'lavfi',
                    '-i', 'nullsrc=s=256x256:d=0.1',  # Tiny test video
                    '-c:v', encoder,
                    '-f', 'null',
                    '-'
                ],
                capture_output=True,
                text=True,
                timeout=10
            )
            
            # If the test encode succeeded, this encoder works!
            if test_result.returncode == 0:
                print(f"GPU encoder {encoder} detected and verified as working")
                return encoder
            else:
                print(f"GPU encoder {encoder} is listed but failed test encode")
                
        except subprocess.TimeoutExpired:
            print(f"GPU encoder {encoder} test timed out")
            continue
        except Exception as e:
            print(f"GPU encoder {encoder} test failed: {str(e)}")
            continue
    
    print("No working GPU encoder found")
    return None

def create_wipe_in_animation(template_array, duration):
    """Wipe-in animation with cloudy soft edge effect"""
    def wipe_in(t):
        wipe_duration = 6.5
        
        if t >= wipe_duration:
            return template_array
        
        progress = t / wipe_duration
        eased_progress = 1 - pow(1 - progress, 3)
        
        result = template_array.copy()
        reveal_width = int(result.shape[1] * eased_progress)
        feather_width = 80
        
        if reveal_width < result.shape[1]:
            result[:, reveal_width + feather_width:, 3] = 0
            
            if reveal_width < result.shape[1] - feather_width:
                for i in range(feather_width):
                    x_pos = reveal_width + i
                    if x_pos < result.shape[1]:
                        alpha_factor = (feather_width - i) / feather_width
                        noise = np.random.rand(result.shape[0]) * 0.3
                        alpha_multiplier = alpha_factor + noise
                        alpha_multiplier = np.clip(alpha_multiplier, 0, 1)
                        result[:, x_pos, 3] = (result[:, x_pos, 3] * alpha_multiplier).astype(np.uint8)
        
        return result
    
    # robust mask handling
    return VideoClip(lambda t: wipe_in(t)[:,:,:3], duration=duration).set_mask(VideoClip(lambda t: wipe_in(t)[:,:,3]/255.0, duration=duration, ismask=True))

def create_fade_in_animation(template_array, duration):
    """Fade-in animation with gradual opacity increase"""
    def fade_in(t):
        fade_duration = 3.0
        
        if t >= fade_duration:
            return template_array
        
        progress = t / fade_duration
        eased_progress = 1 - pow(1 - progress, 2)  # Quadratic ease-out
        
        result = template_array.copy()
        result[:, :, 3] = (result[:, :, 3] * eased_progress).astype(np.uint8)
        
        return result
    
    # robust mask handling
    return VideoClip(lambda t: fade_in(t)[:,:,:3], duration=duration).set_mask(VideoClip(lambda t: fade_in(t)[:,:,3]/255.0, duration=duration, ismask=True))

def create_slide_in_animation(template_array, duration):
    """Slide-in animation from left with easing"""
    def slide_in(t):
        slide_duration = 4.0
        
        if t >= slide_duration:
            return template_array
        
        progress = t / slide_duration
        eased_progress = 1 - pow(1 - progress, 3)  # Cubic ease-out
        
        result = template_array.copy()
        slide_distance = result.shape[1]
        current_offset = int(slide_distance * (1 - eased_progress))
        
        # Shift the image
        if current_offset > 0:
            shifted = np.zeros_like(result)
            shifted[:, current_offset:, :] = result[:, :-current_offset, :]
            return shifted
        
        return result
    
    # robust mask handling
    return VideoClip(lambda t: slide_in(t)[:,:,:3], duration=duration).set_mask(VideoClip(lambda t: slide_in(t)[:,:,3]/255.0, duration=duration, ismask=True))

def create_zoom_in_animation(template_array, duration, video_size):
    """Zoom-in animation with scale from small to full size"""
    def zoom_in(t):
        zoom_duration = 3.5
        
        if t >= zoom_duration:
            return template_array
        
        progress = t / zoom_duration
        eased_progress = 1 - pow(1 - progress, 2)  # Quadratic ease-out
        
        # Scale from 0.3 to 1.0
        scale = 0.3 + (0.7 * eased_progress)
        
        # Calculate new dimensions
        new_height = int(template_array.shape[0] * scale)
        new_width = int(template_array.shape[1] * scale)
        
        if new_height <= 0 or new_width <= 0:
            return np.zeros_like(template_array)
        
        # Resize template
        template_pil = Image.fromarray(template_array)
        scaled_pil = template_pil.resize((new_width, new_height), Image.LANCZOS)
        scaled_array = np.array(scaled_pil)
        
        # Center the scaled image
        result = np.zeros_like(template_array)
        y_offset = (template_array.shape[0] - new_height) // 2
        x_offset = (template_array.shape[1] - new_width) // 2
        
        result[y_offset:y_offset+new_height, x_offset:x_offset+new_width] = scaled_array
        
        return result
    
    # robust mask handling
    return VideoClip(lambda t: zoom_in(t)[:,:,:3], duration=duration).set_mask(VideoClip(lambda t: zoom_in(t)[:,:,3]/255.0, duration=duration, ismask=True))

def create_no_animation(template_array, duration):
    """No animation - instant overlay"""
    # robust mask handling
    return VideoClip(lambda t: template_array[:,:,:3], duration=duration).set_mask(VideoClip(lambda t: template_array[:,:,3]/255.0, duration=duration, ismask=True))


def create_bounce_in_animation(template_array, duration):
    """Bounce-in animation with elastic bounce effect"""
    def bounce_in(t):
        bounce_duration = 3.5
        
        if t >= bounce_duration:
            return template_array
        
        progress = t / bounce_duration
        
        # Elastic bounce easing
        if progress < 0.5:
            eased_progress = 0.5 * pow(2 * progress, 3)
        else:
            p = 2 * progress - 2
            eased_progress = 0.5 * (pow(p, 3) + 2)
        
        # Add bounce overshoot
        bounce_factor = 1.0 + 0.3 * np.sin(progress * np.pi * 4) * (1 - progress)
        scale = eased_progress * bounce_factor
        scale = max(0, min(1.2, scale))  # Clamp between 0 and 1.2
        
        if scale <= 0:
            return np.zeros_like(template_array)
        
        # Scale template
        new_height = int(template_array.shape[0] * scale)
        new_width = int(template_array.shape[1] * scale)
        
        if new_height <= 0 or new_width <= 0:
            return np.zeros_like(template_array)
        
        template_pil = Image.fromarray(template_array)
        scaled_pil = template_pil.resize((new_width, new_height), Image.LANCZOS)
        scaled_array = np.array(scaled_pil)
        
        # Center the scaled image
        result = np.zeros_like(template_array)
        y_offset = (template_array.shape[0] - new_height) // 2
        x_offset = (template_array.shape[1] - new_width) // 2
        
        if y_offset >= 0 and x_offset >= 0:
            result[y_offset:y_offset+new_height, x_offset:x_offset+new_width] = scaled_array
        
        return result
    
    return VideoClip(lambda t: bounce_in(t), duration=duration)

def create_flip_in_animation(template_array, duration):
    """Flip-in animation with 3D flip effect"""
    def flip_in(t):
        flip_duration = 2.5
        
        if t >= flip_duration:
            return template_array
        
        progress = t / flip_duration
        eased_progress = 1 - pow(1 - progress, 2)
        
        # Rotation from 90 to 0 degrees (vertical flip)
        angle = 90 * (1 - eased_progress)
        
        # Simulate 3D perspective by scaling width
        width_scale = abs(np.cos(np.radians(angle)))
        
        result = template_array.copy()
        new_width = int(result.shape[1] * width_scale)
        
        if new_width <= 0:
            return np.zeros_like(template_array)
        
        # Resize horizontally to simulate flip
        template_pil = Image.fromarray(result)
        flipped_pil = template_pil.resize((new_width, result.shape[0]), Image.LANCZOS)
        flipped_array = np.array(flipped_pil)
        
        # Center the flipped image
        final_result = np.zeros_like(template_array)
        x_offset = (template_array.shape[1] - new_width) // 2
        final_result[:, x_offset:x_offset+new_width] = flipped_array
        
        # Fade in during flip
        final_result[:, :, 3] = (final_result[:, :, 3] * eased_progress).astype(np.uint8)
        
        return final_result
    
    return VideoClip(lambda t: flip_in(t), duration=duration)

def create_blur_in_animation(template_array, duration):
    """Blur-in animation - start blurry, become sharp"""
    from scipy.ndimage import gaussian_filter
    
    def blur_in(t):
        blur_duration = 3.0
        
        if t >= blur_duration:
            return template_array
        
        progress = t / blur_duration
        eased_progress = 1 - pow(1 - progress, 2)
        
        # Blur amount from 15 to 0
        blur_amount = 15 * (1 - eased_progress)
        
        if blur_amount < 0.5:
            return template_array
        
        result = template_array.copy()
        
        # Apply gaussian blur to RGB channels
        for i in range(3):
            result[:, :, i] = gaussian_filter(result[:, :, i], sigma=blur_amount)
        
        # Fade in opacity
        result[:, :, 3] = (result[:, :, 3] * eased_progress).astype(np.uint8)
        
        return result
    
    return VideoClip(lambda t: blur_in(t), duration=duration)

def create_spiral_in_animation(template_array, duration):
    """Spiral-in animation with rotation while zooming"""
    def spiral_in(t):
        spiral_duration = 4.0
        
        if t >= spiral_duration:
            return template_array
        
        progress = t / spiral_duration
        eased_progress = 1 - pow(1 - progress, 2)
        
        # Zoom from 0.2 to 1.0
        scale = 0.2 + (0.8 * eased_progress)
        
        # Rotation from 360 to 0 degrees (2 full rotations)
        angle = 720 * (1 - eased_progress)
        
        # Rotate and scale
        template_pil = Image.fromarray(template_array)
        rotated_pil = template_pil.rotate(angle, expand=False, resample=Image.BICUBIC)
        
        new_height = int(template_array.shape[0] * scale)
        new_width = int(template_array.shape[1] * scale)
        
        if new_height <= 0 or new_width <= 0:
            return np.zeros_like(template_array)
        
        scaled_pil = rotated_pil.resize((new_width, new_height), Image.LANCZOS)
        scaled_array = np.array(scaled_pil)
        
        # Center the result
        result = np.zeros_like(template_array)
        y_offset = (template_array.shape[0] - new_height) // 2
        x_offset = (template_array.shape[1] - new_width) // 2
        
        result[y_offset:y_offset+new_height, x_offset:x_offset+new_width] = scaled_array
        
        # Fade in
        result[:, :, 3] = (result[:, :, 3] * eased_progress).astype(np.uint8)
        
        return result
    
    return VideoClip(lambda t: spiral_in(t), duration=duration)

def create_corner_wipe_animation(template_array, duration):
    """Corner wipe animation from top-left corner"""
    def corner_wipe(t):
        wipe_duration = 5.0
        
        if t >= wipe_duration:
            return template_array
        
        progress = t / wipe_duration
        eased_progress = 1 - pow(1 - progress, 3)
        
        result = template_array.copy()
        
        # Diagonal wipe from top-left
        total_distance = result.shape[0] + result.shape[1]
        reveal_distance = int(total_distance * eased_progress)
        
        # Create mask
        for y in range(result.shape[0]):
            for x in range(result.shape[1]):
                distance = y + x
                if distance > reveal_distance:
                    result[y, x, 3] = 0
                elif distance > reveal_distance - 50:
                    # Soft edge
                    alpha_factor = (reveal_distance - distance) / 50.0
                    result[y, x, 3] = int(result[y, x, 3] * (1 - alpha_factor))
        
        return result
    
    return VideoClip(lambda t: corner_wipe(t), duration=duration)

def create_curtain_animation(template_array, duration):
    """Curtain animation - open like curtains from center"""
    def curtain(t):
        curtain_duration = 4.0
        
        if t >= curtain_duration:
            return template_array
        
        progress = t / curtain_duration
        eased_progress = 1 - pow(1 - progress, 3)
        
        result = template_array.copy()
        
        # Open from center
        center_x = result.shape[1] // 2
        reveal_width = int(center_x * eased_progress)
        
        # Hide left and right portions
        left_hide = center_x - reveal_width
        right_hide = center_x + reveal_width
        
        # Soft edge width
        feather = 30
        
        # Apply curtain effect
        for x in range(result.shape[1]):
            if x < left_hide - feather or x > right_hide + feather:
                result[:, x, 3] = 0
            elif x < left_hide:
                # Left soft edge
                alpha_factor = (x - (left_hide - feather)) / feather
                result[:, x, 3] = (result[:, x, 3] * alpha_factor).astype(np.uint8)
            elif x > right_hide:
                # Right soft edge
                alpha_factor = 1 - ((x - right_hide) / feather)
                result[:, x, 3] = (result[:, x, 3] * alpha_factor).astype(np.uint8)
        
        return result
    
    return VideoClip(lambda t: curtain(t), duration=duration)

def overlay_filter(animation, width, height, fade_time=1.5, fps=30):
    """
    Generate overlay filter for given animation type using safe FFmpeg filters.
    Returns tuple: (filter_pre, overlay_opt)
    - filter_pre: Filter chain to process [1:v] into [ov]
    - overlay_opt: Option string for overlay filter (e.g. "x=...:y=...") or None for default
    """
    # Normalize animation name
    animation = animation.replace("-", "_").lower()
    
    t = fade_time
    W = width
    H = height
    
    # Base scaler for consistency (fits template to video size)
    base_scale = f"[1:v]scale={width}:{height},setsar=1"
    
    # -------------------------------------------------------------------------
    # 1. NONE
    # -------------------------------------------------------------------------
    if animation == "none":
        return f"{base_scale}[ov]", None

    # -------------------------------------------------------------------------
    # 2. FADE IN
    # -------------------------------------------------------------------------
    if animation == "fade_in":
        return (
            f"{base_scale},fade=t=in:st=0:d={t}:alpha=1[ov]"
        ), None

    # -------------------------------------------------------------------------
    # 3. WIPE IN
    # -------------------------------------------------------------------------
    if animation == "wipe_in":
        return (
            f"{base_scale},crop='iw*min(t,{t})/{t}':ih:0:0[ov]"
        ), None

    # -------------------------------------------------------------------------
    # 4. SLIDE IN
    # -------------------------------------------------------------------------
    if animation == "slide_in":
        # Slides from Right to Left
        return (
            f"{base_scale}[ov]"
        ), f"x='W*(1-min(t,{t})/{t})':y='(H-h)/2':format=auto"

    # -------------------------------------------------------------------------
    # 5. ZOOM IN
    # -------------------------------------------------------------------------
    if animation == "zoom_in":
        return (
            f"{base_scale},"
            f"scale='iw*(1+0.5*(1-min(t,{t})/{t}))':'ih*(1+0.5*(1-min(t,{t})/{t}))':eval=frame[ov]"
        ), f"overlay=x='(W-w)/2':y='(H-h)/2':format=auto"

    # -------------------------------------------------------------------------
    # 6. BOUNCE IN (Diagonal + Physics)
    # -------------------------------------------------------------------------
    if animation == "bounce_in":
        # 4x duration for slow motion physics
        dur = t * 4
        p = f"min(t,{dur})/{dur}"
        bounce_p = f"max({p}-0.5,0)/0.5"
        
        # Consistent zoom
        scale_filter = f"scale='iw*(1+0.8*pow(1-{p},1.6))':'ih*(1+0.8*pow(1-{p},1.6))':eval=frame"
        
        # X: Left -> Center
        x_expr = f"'if(lte({p},0.5),-{width}+2*{width}*{p},0)+(W-w)/2'"
        # Y: Vertical bounce
        y_expr = f"'if(lte({p},0.5),0,-350*pow(1-{bounce_p},0.4)*sin(6*PI*{bounce_p}))+(H-h)/2'"
        
        return (
            f"{base_scale},{scale_filter}[ov]"
        ), f"overlay=x={x_expr}:y={y_expr}:format=auto"

    # -------------------------------------------------------------------------
    # 7. FLIP IN (Horizontal 6-spin)
    # -------------------------------------------------------------------------
    if animation == "flip_in":
        p = f"min(t,{t})/{t}"
        return (
            f"{base_scale},"
            f"scale='iw*max(abs(cos(6*PI*{p})),0.02)':ih:eval=frame,"
            f"hflip=enable='lt(sin(6*PI*{p}),0)'[ov]"
        ), None

    # -------------------------------------------------------------------------
    # 8. BLUR IN
    # -------------------------------------------------------------------------
    if animation == "blur_in":
        return (
            f"{base_scale},"
            f"boxblur='luma_radius=min(12*(1-min(t,{t})/{t}),12)':luma_power=1[ov]"
        ), None

    # -------------------------------------------------------------------------
    # 9. SPIRAL IN
    # -------------------------------------------------------------------------
    if animation == "spiral_in":
        return (
            f"{base_scale},"
            f"scale='iw*(0.3+0.7*min(t,{t})/{t})':'ih*(0.3+0.7*min(t,{t})/{t})':eval=frame,"
            f"rotate='PI*(1-min(t,{t})/{t})':c=none[ov]"
        ), f"overlay=x='(W-w)/2':y='(H-h)/2':format=auto"

    # -------------------------------------------------------------------------
    # 10. CORNER WIPE
    # -------------------------------------------------------------------------
    if animation == "corner_wipe":
        return (
            f"{base_scale},"
            f"crop='iw*min(t,{t})/{t}':'ih*min(t,{t})/{t}':0:0[ov]"
        ), None

    # -------------------------------------------------------------------------
    # 11. CURTAIN
    # -------------------------------------------------------------------------
    if animation == "curtain":
        return (
            f"{base_scale},"
            f"crop='iw*min(t,{t})/{t}':ih:'(iw-iw*min(t,{t})/{t})/2':0[ov]"
        ), None
        
    # -------------------------------------------------------------------------
    # 12. BOUNCE DROP (New)
    # -------------------------------------------------------------------------
    if animation == "bounce_drop":
        dur = t * 4
        p = f"min(t,{dur})/{dur}"
        bounce_p = f"max({p}-0.5,0)/0.5"
        scale_filter = f"scale='iw*(1+0.5*pow(1-{p},3))':'ih*(1+0.5*pow(1-{p},3))':eval=frame"
        
        x_expr = f"'(W-w)/2'"
        y_expr = f"'if(lte({p},0.5),-{height}+{height}*{p},0)+(H-h)/2 - 350*pow(1-{bounce_p},0.4)*sin(6*PI*{bounce_p})'"
        
        return (
            f"{base_scale},{scale_filter}[ov]"
        ), f"overlay=x={x_expr}:y={y_expr}:format=auto"

    # -------------------------------------------------------------------------
    # 13. BOUNCE SLIDE (New - From Right)
    # -------------------------------------------------------------------------
    if animation == "bounce_slide":
        dur = t * 4
        p = f"min(t,{dur})/{dur}"
        bounce_p = f"max({p}-0.5,0)/0.5"
        scale_filter = f"scale='iw*(1+0.5*pow(1-{p},3))':'ih*(1+0.5*pow(1-{p},3))':eval=frame"
        
        x_expr = f"'if(lte({p},0.5),{width}-{width}*{p},0)+(W-w)/2 + 350*pow(1-{bounce_p},0.4)*sin(6*PI*{bounce_p})'"
        y_expr = f"'(H-h)/2'"
        
        return (
            f"{base_scale},{scale_filter}[ov]"
        ), f"overlay=x={x_expr}:y={y_expr}:format=auto"

    # -------------------------------------------------------------------------
    # 14. FLIP VERTICAL (New)
    # -------------------------------------------------------------------------
    if animation == "flip_vertical":
        p = f"min(t,{t})/{t}"
        fp = f"min(max(({p}-0.5)/0.25,0),1)"
        return (
            f"{base_scale},"
            f"scale=iw:'ih*max(pow(abs(1-2*{fp}),0.7),0.02)':eval=frame,"
            f"vflip=enable='gte({fp},0.5)'[ov]"
        ), None

    # -------------------------------------------------------------------------
    # 15. FLASH ZOOM (New)
    # -------------------------------------------------------------------------
    if animation == "flash_zoom":
        return (
            f"{base_scale},"
            f"scale='iw*(1+0.6*(1-min(t,{t})/{t}))':'ih*(1+0.6*(1-min(t,{t})/{t}))':eval=frame,"
            f"eq=brightness='0.5*pow(1-min(t,{t})/{t},2)':saturation=1[ov]"
        ), f"overlay=x='(W-w)/2':y='(H-h)/2':format=auto"

    # -------------------------------------------------------------------------
    # 16. ELASTIC SCALE (New)
    # -------------------------------------------------------------------------
    if animation == "elastic_scale":
        p = f"min(t,{t})/{t}"
        return (
            f"{base_scale},"
            f"scale='iw*(1+0.5*pow(1-{p},2)*cos(3*PI*{p}))':'ih*(1+0.5*pow(1-{p},2)*cos(3*PI*{p}))':eval=frame[ov]"
        ), f"overlay=x='(W-w)/2':y='(H-h)/2':format=auto"

    # -------------------------------------------------------------------------
    # 17. SPIN REVEAL (New)
    # -------------------------------------------------------------------------
    if animation == "spin_reveal":
        p = f"min(t,{t})/{t}"
        return (
            f"{base_scale},"
            f"scale='iw*(0.1+0.9*{p})':'ih*(0.1+0.9*{p})':eval=frame,"
            f"rotate='2*PI*(1-pow({p},0.5))':c=none[ov]"
        ), f"overlay=x='(W-w)/2':y='(H-h)/2':format=auto"

    # Default to wipe_in if unknown
    print(f"Warning: Unknown animation '{animation}', defaulting to wipe_in")
    return (
        f"{base_scale},crop='iw*min(t,{t})/{t}':ih:0:0[ov]"
    ), None


def generate_video_moviepy(bg_video_path, template_path, output_path, animation_type):
    """
    Generate video using parallel_video_generator.py (CPU fallback with working MoviePy logic).
    """
    try:
        print(f"CPU Fallback: Using parallel_video_generator.py for {animation_type}...")
        
        # Prepare task JSON for parallel generator
        task = {
            'bg_video': bg_video_path,
            'template': template_path,
            'output': output_path,
            'animation': animation_type
        }
        
        tasks_json = json.dumps([task])
        
        # Get script path
        script_dir = os.path.dirname(os.path.abspath(__file__))
        parallel_script = os.path.join(script_dir, 'parallel_video_generator.py')
        
        # Call parallel_video_generator.py
        cmd = [sys.executable, parallel_script, tasks_json]
        
        print(f"Executing: {' '.join(cmd[:2])} '<json>'")
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            env={**os.environ, 'USE_GPU': '0'}  # Force CPU mode
        )
        
        # Check result
        if result.returncode == 0:
            # Parse output for duration
            output_lines = result.stdout.strip().split('\n')
            
            # Try to extract duration from video file
            try:
                probe_cmd = [
                    "ffprobe", "-v", "error",
                    "-select_streams", "v:0",
                    "-show_entries", "stream=duration",
                    "-of", "csv=p=0",
                    output_path
                ]
                probe_result = subprocess.run(probe_cmd, capture_output=True, text=True)
                duration = float(probe_result.stdout.strip()) if probe_result.returncode == 0 else 0.0
            except:
                duration = 0.0
            
            print(f"SUCCESS: Video generated via parallel_video_generator.py")
            return {'success': True, 'duration': duration, 'output_path': output_path}
        else:
            error_msg = result.stderr if result.stderr else result.stdout
            raise Exception(f"parallel_video_generator.py failed: {error_msg}")
        
    except Exception as e:
        print(f"CPU Fallback Error: {e}")
        raise e


def detect_gpu_encoder():
    """Detect available GPU encoder (NVENC preference)"""
    # Check if GPU acceleration is enabled via environment variable
    use_gpu = os.environ.get('USE_GPU', '1')
    if use_gpu != '1':
        print("GPU acceleration disabled via USE_GPU environment variable")
        return None
    
    try:
        import subprocess
        cmd = ['ffmpeg', '-v', 'error', '-encoders']
        result = subprocess.run(cmd, capture_output=True, text=True)
        # Check for NVENC
        if 'h264_nvenc' in result.stdout:
            return 'h264_nvenc'
        # Check for QSV (Intel) if needed, but sticking to NVENC/CPU for stability
        # if 'h264_qsv' in result.stdout: return 'h264_qsv'
        return None
    except Exception:
        return None


def generate_video(bg_video_path, template_path, output_path, animation_type='wipe-in'):
    """
    Generate video using direct FFmpeg command for maximum performance and stability.
    Integrates 11 distinct animation types.
    """
    try:
        import subprocess
        
        # Validate inputs
        if not os.path.exists(bg_video_path):
            raise FileNotFoundError(f"Background video not found: {bg_video_path}")
        if not os.path.exists(template_path):
            raise FileNotFoundError(f"Template image not found: {template_path}")
            
        # Ensure output dir
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        
        # Get video dimensions using ffprobe
        probe_cmd = [
            "ffprobe", "-v", "error", 
            "-select_streams", "v:0",
            "-show_entries", "stream=width,height,duration", 
            "-of", "csv=s=x:p=0", 
            bg_video_path
        ]
        
        # Use shell=True on Windows to avoid path issues if needed, but list is safer
        # Using list with full paths
        result = subprocess.run(probe_cmd, capture_output=True, text=True, check=True)
        w_str, h_str, d_str = result.stdout.strip().split('x')
        width = int(w_str)
        height = int(h_str)
        duration = float(d_str) if d_str != 'N/A' else 15.0 # Default if N/A
        
        print(f"Video Info: {width}x{height}, {duration}s")
        print(f"Animation: {animation_type}")
        
        # get filter chains
        filter_pre, overlay_opt = overlay_filter(animation_type, width, height)
        
        # Construct filter complex
        if overlay_opt:
            # Complex overlay (e.g. bounce, zoom) where position moves
            filter_complex = f"{filter_pre};[0:v][ov]{overlay_opt}"
        else:
            # Simple overlay (position static 0:0, or handled by pad)
            if "[ov]" in filter_pre:
                filter_complex = f"{filter_pre};[0:v][ov]overlay=0:0:format=auto"
            else:
                 # Should not happen with current overlay_filter impl
                filter_complex = f"[1:v]scale={width}:{height}[ov];[0:v][ov]overlay=0:0"
                
        # Build FFmpeg command
        # Using NVENC if available
        gpu_codec = detect_gpu_encoder()
        
        # CPU Fallback with High-Quality MoviePy Animations
        # Use MoviePy logic if GPU is missing AND animation is one of the basic types supported by the MoviePy script
        basic_animations = ['wipe-in', 'fade-in', 'slide-in', 'zoom-in', 'none']
        if not gpu_codec and animation_type in basic_animations:
            print(f"Encoder: CPU (Switching to MoviePy for high-quality '{animation_type}')")
            return generate_video_moviepy(bg_video_path, template_path, output_path, animation_type)
        print(f"Encoder: {gpu_codec if gpu_codec else 'CPU (libx264)'}")
        
        cmd = [
            "ffmpeg", "-y",
            "-i", bg_video_path,
            "-i", template_path,
            "-filter_complex", filter_complex,
            "-c:a", "copy",   # Copy audio from bg video
            "-shortest",      # Stop when shortest input ends (bg video)
        ]
        
        if gpu_codec == 'h264_nvenc':
            cmd.extend([
                "-c:v", "h264_nvenc",
                "-preset", "p4",  # Balanced preset
                "-rc", "vbr",
                "-cq", "24",
                "-b:v", "6M",
                "-maxrate", "9M",
                "-bufsize", "12M"
            ])
        else:
            cmd.extend([
                "-c:v", "libx264",
                "-preset", "ultrafast",
                "-crf", "23"
            ])
            
        cmd.append(output_path)
        
        print("Running FFmpeg...")
        subprocess.run(cmd, check=True)
        
        # Verify output
        if os.path.exists(output_path) and os.path.getsize(output_path) > 1000:
            print(f"SUCCESS: Video generated at {output_path}")
            return {'success': True, 'duration': duration, 'output_path': output_path}
        else:
            raise Exception("Output file missing or empty")

    except Exception as e:
        print(f"ERROR: {str(e)}", file=sys.stderr)
        return {'success': False, 'error': str(e)}

def main():
    """
    Main function to handle command line arguments
    """
    # Check for GPU status flag
    if len(sys.argv) == 2 and sys.argv[1] == '--check-gpu':
        import json
        status = get_gpu_status()
        print(json.dumps(status))
        sys.exit(0)
    
    if len(sys.argv) < 4 or len(sys.argv) > 5:
        print("Usage: python video_generator.py <background_video> <template_image> <output_video> [animation_type]")
        print("       python video_generator.py --check-gpu")
        print("\nAvailable animations (11 types):")
        print("  wipe-in      - Left to right reveal (default)")
        print("  fade-in      - Gradual opacity")
        print("  slide-in     - Slide from left")
        print("  zoom-in      - Scale up")
        print("  bounce-in    - Elastic bounce")
        print("  flip-in      - 3D flip")
        print("  blur-in      - Blur to sharp")
        print("  spiral-in    - Spin and zoom")
        print("  corner-wipe  - Diagonal from corner")
        print("  curtain      - Open from center")
        print("  none         - Instant overlay")
        print("\nExample: python video_generator.py bg.mp4 template.png output.mp4 fade-in")
        sys.exit(1)
    
    bg_video_path = sys.argv[1]
    template_path = sys.argv[2]
    output_path = sys.argv[3]
    animation_type = sys.argv[4] if len(sys.argv) == 5 else 'wipe-in'
    
    print("=" * 60)
    print("Video Generator Script")
    print("=" * 60)
    print(f"Background Video: {bg_video_path}")
    print(f"Template Image: {template_path}")
    print(f"Output Video: {output_path}")
    print(f"Animation Type: {animation_type}")
    print("=" * 60)
    
    result = generate_video(bg_video_path, template_path, output_path, animation_type)
    
    if result['success']:
        print("=" * 60)
        print("Video generation completed successfully!")
        print(f"Output saved to: {result['output_path']}")
        print(f"Duration: {result['duration']}s")
        print("=" * 60)
        sys.exit(0)
    else:
        print("=" * 60)
        print("Video generation failed!")
        print(f"Error: {result['error']}")
        print("=" * 60)
        sys.exit(1)

if __name__ == "__main__":
    main()
