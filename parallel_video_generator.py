#!/usr/bin/env python
"""
Parallel Video Generator Script
Processes multiple videos simultaneously using multiprocessing
Significantly faster than sequential processing
"""

import sys
import os
import json
import subprocess
from multiprocessing import Pool, cpu_count
from moviepy.editor import *
import numpy as np
import numpy as np
from PIL import Image

# Get FFmpeg binary from environment (set by PHP job) or default to 'ffmpeg'
FFMPEG_BIN = os.environ.get('IMAGEIO_FFMPEG_EXE', 'ffmpeg')
print(f"Using FFmpeg binary: {FFMPEG_BIN}")

def detect_gpu_encoder():
    """
    Detect available GPU encoder for hardware acceleration
    Returns tuple of (codec_name, extra_params, use_cuda_decode) or (None, None, False) if no GPU encoder available
    
    This function actually tests if the encoder works with proper parameters
    Environment variables:
    - USE_GPU: '1' to enable GPU, '0' to disable
    - FORCE_NVENC: '1' to force NVENC without testing (use with caution)
    - USE_CUDA_DECODE: '1' to enable CUDA hardware decoding (GTX 1650 recommended)
    """
    # Check if GPU acceleration is enabled via environment variable
    use_gpu = os.environ.get('USE_GPU', '1')
    if use_gpu != '1':
        print("GPU acceleration disabled via configuration")
        return None, None, False
    
    # Check if CUDA hardware decoding should be used
    use_cuda_decode = os.environ.get('USE_CUDA_DECODE', '1') == '1'
    
    # Check if NVENC should be forced (skip testing)
    force_nvenc = os.environ.get('FORCE_NVENC', '0')
    if force_nvenc == '1':
        print("WARNING: FORCE_NVENC enabled - using h264_nvenc without testing")
        print(f"   CUDA hardware decoding: {'ENABLED' if use_cuda_decode else 'DISABLED'}")
        # Optimized for GTX 1650: Use VBR with quality target
        nvenc_params = {
            'rc': 'vbr',
            'cq': 23,
            'b': '5M',
            'maxrate': '10M',
            'preset': 'p1',  # p1 = fastest (GTX 1650 optimized for speed)
            'gpu': '0'  # Use first GPU
        }
        return 'h264_nvenc', nvenc_params, use_cuda_decode
    
    # Try NVENC with multiple parameter combinations
    nvenc_configs = [
        # Config 1: VBR with quality target (GTX 1650 optimized)
        {
            'encoder': 'h264_nvenc',
            'test_params': ['-rc', 'vbr', '-cq', '23', '-b:v', '5M', '-preset', 'p1'],
            'encode_params': {'rc': 'vbr', 'cq': 23, 'b': '5M', 'maxrate': '10M', 'preset': 'p1', 'gpu': '0'}
        },
        # Config 2: CBR (Constant Bitrate)
        {
            'encoder': 'h264_nvenc',
            'test_params': ['-b:v', '5M'],
            'encode_params': {'b': '5M'}
        },
        # Config 3: Simple NVENC without rate control
        {
            'encoder': 'h264_nvenc',
            'test_params': [],
            'encode_params': {}
        },
    ]
    
    # Check if NVENC is listed
    try:
        list_result = subprocess.run(
            [FFMPEG_BIN, '-hide_banner', '-encoders'],
            capture_output=True,
            text=True,
            timeout=5
        )
        
        if 'h264_nvenc' in list_result.stdout:
            print("h264_nvenc encoder found in FFmpeg, testing configurations...")
            
            for config in nvenc_configs:
                try:
                    test_cmd = [
                        FFMPEG_BIN, '-y',
                        '-f', 'lavfi',
                        '-i', 'testsrc=s=256x256:d=0.1',
                        '-c:v', config['encoder']
                    ] + config['test_params'] + ['-f', 'null', '-']
                    
                    print(f"Testing NVENC with params: {config['test_params']}")
                    test_result = subprocess.run(
                        test_cmd,
                        capture_output=True,
                        text=True,
                        timeout=10
                    )
                    
                    if test_result.returncode == 0:
                        print(f"[OK] NVENC working with config: {config['encode_params']}")
                        print(f"   CUDA hardware decoding: {'ENABLED' if use_cuda_decode else 'DISABLED'}")
                        return config['encoder'], config['encode_params'], use_cuda_decode
                    else:
                        print(f"[FAIL] NVENC failed with this config")
                        if 'Cannot load nvcuda.dll' in test_result.stderr:
                            print("  Error: CUDA library not found - NVIDIA drivers may need update")
                        elif 'No NVENC capable devices found' in test_result.stderr:
                            print("  Error: No NVENC capable GPU detected")
                        
                except subprocess.TimeoutExpired:
                    print(f"[FAIL] NVENC test timed out")
                    continue
                except Exception as e:
                    print(f"[FAIL] NVENC test error: {str(e)}")
                    continue
            
            print("All NVENC configurations failed, trying other encoders...")
    except Exception as e:
        print(f"Error checking for NVENC: {str(e)}")
    
    # Fallback to other GPU encoders
    other_encoders = [
        ('h264_qsv', {}),      # Intel Quick Sync
        ('h264_amf', {}),      # AMD GPU
    ]
    
    for encoder, params in other_encoders:
        try:
            list_result = subprocess.run(
                [FFMPEG_BIN, '-hide_banner', '-encoders'],
                capture_output=True,
                text=True,
                timeout=5
            )
            
            if encoder not in list_result.stdout:
                continue
            
            test_result = subprocess.run(
                [
                    FFMPEG_BIN,
                    '-f', 'lavfi',
                    '-i', 'nullsrc=s=256x256:d=0.1',
                    '-c:v', encoder,
                    '-f', 'null',
                    '-'
                ],
                capture_output=True,
                text=True,
                timeout=10
            )
            
            if test_result.returncode == 0:
                print(f"GPU encoder {encoder} detected and verified as working")
                return encoder, params, False  # Other encoders don't support CUDA decode
                
        except Exception:
            continue
    
    print("No working GPU encoder found, will use CPU encoding")
    return None, None, False  # No GPU encoder found, will use CPU

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

def create_blur_in_animation(template_array, duration):
    """Enhanced blur-in animation - start VERY blurry, become sharp"""
    from scipy.ndimage import gaussian_filter
    
    def blur_in(t):
        # ENHANCED: Increased duration for more visible effect
        blur_duration = 5.0  # Changed from 3.0 to 5.0
        
        if t >= blur_duration:
            return template_array
        
        progress = t / blur_duration
        eased_progress = 1 - pow(1 - progress, 2)  # Quadratic ease-out
        
        # ENHANCED: Increased blur amount for more dramatic effect
        blur_amount = 30 * (1 - eased_progress)  # Changed from 15 to 30
        
        if blur_amount < 0.5:
            return template_array
        
        result = template_array.copy()
        
        # Apply gaussian blur to RGB channels
        for i in range(3):
            result[:, :, i] = gaussian_filter(result[:, :, i], sigma=blur_amount)
        
        # ENHANCED: Slower opacity fade-in for smoother appearance
        opacity_progress = pow(eased_progress, 0.5)  # Square root for slower start
        result[:, :, 3] = (result[:, :, 3] * opacity_progress).astype(np.uint8)
        
        return result
    
    # Separate RGB and alpha channels for proper compositing
    rgb_clip = VideoClip(lambda t: blur_in(t)[:,:,:3], duration=duration)
    mask_clip = VideoClip(lambda t: blur_in(t)[:,:,3]/255.0, duration=duration, ismask=True)
    
    return rgb_clip.set_mask(mask_clip)

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
    
    rgb_clip = VideoClip(lambda t: bounce_in(t)[:,:,:3], duration=duration)
    mask_clip = VideoClip(lambda t: bounce_in(t)[:,:,3]/255.0, duration=duration, ismask=True)
    return rgb_clip.set_mask(mask_clip)

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
    
    rgb_clip = VideoClip(lambda t: flip_in(t)[:,:,:3], duration=duration)
    mask_clip = VideoClip(lambda t: flip_in(t)[:,:,3]/255.0, duration=duration, ismask=True)
    return rgb_clip.set_mask(mask_clip)

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
    
    rgb_clip = VideoClip(lambda t: spiral_in(t)[:,:,:3], duration=duration)
    mask_clip = VideoClip(lambda t: spiral_in(t)[:,:,3]/255.0, duration=duration, ismask=True)
    return rgb_clip.set_mask(mask_clip)

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
    
    rgb_clip = VideoClip(lambda t: corner_wipe(t)[:,:,:3], duration=duration)
    mask_clip = VideoClip(lambda t: corner_wipe(t)[:,:,3]/255.0, duration=duration, ismask=True)
    return rgb_clip.set_mask(mask_clip)

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
    
    rgb_clip = VideoClip(lambda t: curtain(t)[:,:,:3], duration=duration)
    mask_clip = VideoClip(lambda t: curtain(t)[:,:,3]/255.0, duration=duration, ismask=True)
    return rgb_clip.set_mask(mask_clip)

def generate_single_video(args):
    """
    Generate a single video - designed to be called by multiprocessing
    
    Args:
        args: tuple of (bg_video_path, template_path, output_path, animation_type, video_index)
    
    Returns:
        dict: Result with success status and video info
    """
    bg_video_path, template_path, output_path, animation_type, video_index = args
    
    try:
        import time
        start_time = time.time()
        print(f"[Worker {video_index}] Starting video generation...")
        
        # Validate inputs
        if not os.path.exists(bg_video_path):
            return {
                'success': False,
                'index': video_index,
                'error': f'Background video not found: {bg_video_path}'
            }
        
        if not os.path.exists(template_path):
            return {
                'success': False,
                'index': video_index,
                'error': f'Template not found: {template_path}'
            }
        
        # Ensure output directory exists
        output_dir = os.path.dirname(output_path)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir, exist_ok=True)
        
        # Detect available GPU encoder first
        gpu_codec, gpu_params, use_cuda_decode = detect_gpu_encoder()
        
        # Load background video (CUDA decoding info will be used during encoding)
        if use_cuda_decode and gpu_codec:
            print(f"[Worker {video_index}] CUDA hardware decoding will be used during encoding")
        
        bg = VideoFileClip(bg_video_path)
        duration = bg.duration
        video_width, video_height = bg.size
        
        # Load and resize template
        template_pil = Image.open(template_path).convert("RGBA")
        scale_factor = video_height / template_pil.height
        new_width = int(template_pil.width * scale_factor)
        new_height = video_height
        template_resized = template_pil.resize((new_width, new_height), Image.LANCZOS)
        template_array = np.array(template_resized)
        
        # Create overlay based on animation type
        if animation_type == 'wipe-in':
            overlay = create_wipe_in_animation(template_array, duration)
        elif animation_type == 'fade-in':
            overlay = create_fade_in_animation(template_array, duration)
        elif animation_type == 'slide-in':
            overlay = create_slide_in_animation(template_array, duration)
        elif animation_type == 'zoom-in':
            overlay = create_zoom_in_animation(template_array, duration, (video_width, video_height))
        elif animation_type == 'bounce-in':
            overlay = create_bounce_in_animation(template_array, duration)
        elif animation_type == 'flip-in':
            overlay = create_flip_in_animation(template_array, duration)
        elif animation_type == 'blur-in':
            overlay = create_blur_in_animation(template_array, duration)
        elif animation_type == 'spiral-in':
            overlay = create_spiral_in_animation(template_array, duration)
        elif animation_type == 'corner-wipe':
            overlay = create_corner_wipe_animation(template_array, duration)
        elif animation_type == 'curtain':
            overlay = create_curtain_animation(template_array, duration)
        elif animation_type == 'none':
            overlay = create_no_animation(template_array, duration)
        else:  # Default to wipe-in
            overlay = create_wipe_in_animation(template_array, duration)
        
        overlay = overlay.set_position(('center', 'center'))
        
        # Composite
        final = CompositeVideoClip([bg, overlay], size=(video_width, video_height))
        
        # Export with GPU acceleration if available
        if gpu_codec:
            print(f"[Worker {video_index}] Using GPU encoder: {gpu_codec} with params: {gpu_params}")
            try:
                # Build ffmpeg_params for GPU encoding
                ffmpeg_params = []
                
                # Add CUDA hardware decoding for input if enabled
                if use_cuda_decode:
                    # These will be added to the input options
                    print(f"[Worker {video_index}] CUDA decode enabled - GPU will handle video decoding")
                
                # Add NVENC-specific parameters
                if gpu_params:
                    if 'gpu' in gpu_params:
                        ffmpeg_params.extend(['-gpu', str(gpu_params['gpu'])])
                    if 'rc' in gpu_params:
                        ffmpeg_params.extend(['-rc', gpu_params['rc']])
                    if 'cq' in gpu_params:
                        ffmpeg_params.extend(['-cq', str(gpu_params['cq'])])
                    if 'b' in gpu_params:
                        ffmpeg_params.extend(['-b:v', gpu_params['b']])
                    if 'maxrate' in gpu_params:
                        ffmpeg_params.extend(['-maxrate', gpu_params['maxrate']])
                    if 'preset' in gpu_params:
                        ffmpeg_params.extend(['-preset', gpu_params['preset']])
                    if 'multipass' in gpu_params:
                        ffmpeg_params.extend(['-multipass', gpu_params['multipass']])
                
                # FIX COLOR SHIFT: Force full range RGB to YUV conversion
                ffmpeg_params.extend([
                    '-pix_fmt', 'yuv420p',           # Standard pixel format
                    '-colorspace', 'bt709',          # HD color space
                    '-color_primaries', 'bt709',     # HD primaries
                    '-color_trc', 'bt709',           # HD transfer
                    '-color_range', 'tv'             # Limited range (16-235) - standard for video
                ])
                
                final.write_videofile(
                    output_path,
                    fps=24,
                    codec=gpu_codec,
                    audio_codec="aac",
                    ffmpeg_params=ffmpeg_params if ffmpeg_params else None,
                    logger=None
                )
            except Exception as gpu_error:
                print(f"[Worker {video_index}] GPU encoding failed, falling back to CPU: {str(gpu_error)}")
                # Fallback to CPU encoding
                final.write_videofile(
                    output_path,
                    fps=24,
                    codec="libx264",
                    preset='ultrafast',
                    audio_codec="aac",
                    threads=2,
                    logger=None
                )
        else:
            # CPU encoding (original)
            print(f"[Worker {video_index}] Using CPU encoder (no GPU detected)")
            final.write_videofile(
                output_path,
                fps=24,
                codec="libx264",
                preset='ultrafast',
                audio_codec="aac",
                threads=2,
                logger=None
            )
        
        # Clean up
        bg.close()
        final.close()
        
        # Print in format that monitor script expects
        import os
        import time
        end_time = time.time()
        elapsed = end_time - start_time if 'start_time' in locals() else 0
        file_size = os.path.getsize(output_path) / (1024 * 1024) if os.path.exists(output_path) else 0
        filename = os.path.basename(output_path)
        print(f"[FFmpeg] SUCCESS: {filename} ({elapsed:.2f}s, {file_size:.2f}MB)")
        
        return {
            'success': True,
            'index': video_index,
            'duration': duration,
            'output_path': output_path
        }
        
    except Exception as e:
        print(f"[Worker {video_index}] ERROR: {str(e)}")
        return {
            'success': False,
            'index': video_index,
            'error': str(e)
        }

def main():
    """
    Main function - processes multiple videos in parallel
    
    Expected input: JSON string with array of video generation tasks
    Format: [
        {
            "bg_video": "path/to/bg.mp4",
            "template": "path/to/template.png",
            "output": "path/to/output.mp4",
            "animation": "wipe-in"
        },
        ...
    ]
    """
    if len(sys.argv) != 2:
        print("Usage: python parallel_video_generator.py '<json_tasks>'")
        print("Example: python parallel_video_generator.py '[{\"bg_video\":\"bg.mp4\",\"template\":\"t.png\",\"output\":\"out.mp4\",\"animation\":\"fade-in\"}]'")
        sys.exit(1)
    
    try:
        # Parse JSON input (support file path or raw JSON)
        input_arg = sys.argv[1]
        if os.path.exists(input_arg) and os.path.isfile(input_arg):
            with open(input_arg, 'r', encoding='utf-8') as f:
                tasks = json.load(f)
        else:
            tasks = json.loads(input_arg)
        
        if not tasks or len(tasks) == 0:
            print("ERROR: No tasks provided")
            sys.exit(1)
        
        print("=" * 60)
        print("Parallel Video Generator")
        print("=" * 60)
        print(f"Total videos to generate: {len(tasks)}")
        
        # Determine number of parallel workers
        num_cores = cpu_count()
        
        # For GPU encoding, we can use more workers since NVENC can handle multiple streams
        # Check if GPU is being used
        use_gpu = os.environ.get('USE_GPU', '1')
        force_nvenc = os.environ.get('FORCE_NVENC', '0')
        
        if use_gpu == '1' or force_nvenc == '1':
            # GPU encoding: NVENC can handle 16+ parallel streams efficiently
            max_workers = 128
            print("GPU encoding enabled - using higher worker count for better GPU utilization")
        else:
            # CPU encoding: limited by CPU cores
            max_workers = 8
        
        num_workers = min(num_cores, len(tasks), max_workers)
        num_workers = max(1, num_workers)  # At least 1 worker
        
        print(f"CPU cores available: {num_cores}")
        print(f"Parallel workers: {num_workers}")
        print("=" * 60)
        
        # Prepare arguments for each video
        video_args = []
        for i, task in enumerate(tasks):
            video_args.append((
                task['bg_video'],
                task['template'],
                task['output'],
                task.get('animation', 'wipe-in'),
                i + 1
            ))
        
        # Process videos in parallel
        with Pool(processes=num_workers) as pool:
            results = pool.map(generate_single_video, video_args)
        
        # Analyze results
        successful = sum(1 for r in results if r['success'])
        failed = len(results) - successful
        
        print("=" * 60)
        print("Video Generation Complete!")
        print(f"Total: {len(results)} | Success: {successful} | Failed: {failed}")
        print("=" * 60)
        
        # Output results as JSON for PHP to parse
        print("RESULTS_JSON_START")
        print(json.dumps(results))
        print("RESULTS_JSON_END")
        
        # Exit with appropriate code
        sys.exit(0 if failed == 0 else 1)
        
    except json.JSONDecodeError as e:
        print(f"ERROR: Invalid JSON input: {str(e)}")
        sys.exit(1)
    except Exception as e:
        print(f"ERROR: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()
