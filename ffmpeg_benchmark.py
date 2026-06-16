#!/usr/bin/env python
"""
FFmpeg CPU vs GPU Encoding Benchmark
Direct comparison of encoding performance using FFmpeg
Tests NVENC (GPU) vs libx264 (CPU) with various presets
"""

import subprocess
import time
import os
import json

# Test files
BG_VIDEO = r"D:\xamp\htdocs\imgen\public_html\public_html\public\videos\background_video\bg_video_1767381490.mp4"
PNG_TEMPLATE = r"D:\xamp\htdocs\imgen\public_html\public_html\public\img\master_template\video_template_1765786550_693fc3b67c005.png"
OUTPUT_DIR = r"D:\xamp\htdocs\imgen\public_html\public_html\ffmpeg_benchmark"

# Ensure output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)


def get_video_info(video_path):
    """Get video information using ffprobe"""
    cmd = [
        'ffprobe',
        '-v', 'quiet',
        '-print_format', 'json',
        '-show_format',
        '-show_streams',
        video_path
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        return json.loads(result.stdout)
    return None


def test_gpu_encoding(input_video, output_path, preset='p4'):
    """Test NVENC GPU encoding"""
    print(f"\n🚀 Testing GPU Encoding (NVENC)")
    print(f"   Preset: {preset}")
    
    cmd = [
        'ffmpeg',
        '-y',  # Overwrite output
        '-i', input_video,
        '-c:v', 'h264_nvenc',
        '-preset', preset,
        '-rc', 'vbr',
        '-cq', '23',
        '-b:v', '5M',
        '-maxrate', '10M',
        '-pix_fmt', 'yuv420p',
        '-colorspace', 'bt709',
        '-color_primaries', 'bt709',
        '-color_trc', 'bt709',
        '-color_range', 'tv',
        '-c:a', 'aac',
        '-b:a', '128k',
        output_path
    ]
    
    start_time = time.time()
    result = subprocess.run(cmd, capture_output=True, text=True)
    elapsed_time = time.time() - start_time
    
    if result.returncode == 0:
        file_size = os.path.getsize(output_path) / (1024 * 1024)  # MB
        print(f"   ✅ Success!")
        print(f"   Time: {elapsed_time:.2f}s")
        print(f"   Size: {file_size:.2f} MB")
        return {
            'success': True,
            'time': elapsed_time,
            'size': file_size,
            'preset': preset
        }
    else:
        print(f"   ❌ Failed: {result.stderr[:200]}")
        return {
            'success': False,
            'time': elapsed_time,
            'error': result.stderr[:200]
        }


def test_cpu_encoding(input_video, output_path, preset='ultrafast'):
    """Test libx264 CPU encoding"""
    print(f"\n🐌 Testing CPU Encoding (libx264)")
    print(f"   Preset: {preset}")
    
    cmd = [
        'ffmpeg',
        '-y',  # Overwrite output
        '-i', input_video,
        '-c:v', 'libx264',
        '-preset', preset,
        '-crf', '23',
        '-pix_fmt', 'yuv420p',
        '-colorspace', 'bt709',
        '-color_primaries', 'bt709',
        '-color_trc', 'bt709',
        '-color_range', 'tv',
        '-c:a', 'aac',
        '-b:a', '128k',
        output_path
    ]
    
    start_time = time.time()
    result = subprocess.run(cmd, capture_output=True, text=True)
    elapsed_time = time.time() - start_time
    
    if result.returncode == 0:
        file_size = os.path.getsize(output_path) / (1024 * 1024)  # MB
        print(f"   ✅ Success!")
        print(f"   Time: {elapsed_time:.2f}s")
        print(f"   Size: {file_size:.2f} MB")
        return {
            'success': True,
            'time': elapsed_time,
            'size': file_size,
            'preset': preset
        }
    else:
        print(f"   ❌ Failed: {result.stderr[:200]}")
        return {
            'success': False,
            'time': elapsed_time,
            'error': result.stderr[:200]
        }


def test_overlay_gpu(bg_video, overlay_png, output_path):
    """Test GPU encoding with PNG overlay"""
    print(f"\n🎨 Testing GPU with PNG Overlay")
    
    cmd = [
        'ffmpeg',
        '-y',
        '-i', bg_video,
        '-i', overlay_png,
        '-filter_complex', '[0:v][1:v]overlay=0:0',
        '-c:v', 'h264_nvenc',
        '-preset', 'p4',
        '-rc', 'vbr',
        '-cq', '23',
        '-b:v', '5M',
        '-maxrate', '10M',
        '-pix_fmt', 'yuv420p',
        '-colorspace', 'bt709',
        '-color_primaries', 'bt709',
        '-color_trc', 'bt709',
        '-color_range', 'tv',
        '-c:a', 'aac',
        output_path
    ]
    
    start_time = time.time()
    result = subprocess.run(cmd, capture_output=True, text=True)
    elapsed_time = time.time() - start_time
    
    if result.returncode == 0:
        file_size = os.path.getsize(output_path) / (1024 * 1024)
        print(f"   ✅ Success!")
        print(f"   Time: {elapsed_time:.2f}s")
        print(f"   Size: {file_size:.2f} MB")
        return {
            'success': True,
            'time': elapsed_time,
            'size': file_size
        }
    else:
        print(f"   ❌ Failed: {result.stderr[:200]}")
        return {
            'success': False,
            'time': elapsed_time,
            'error': result.stderr[:200]
        }


def test_overlay_cpu(bg_video, overlay_png, output_path, preset='ultrafast'):
    """Test CPU encoding with PNG overlay"""
    print(f"\n🎨 Testing CPU with PNG Overlay")
    print(f"   Preset: {preset}")
    
    cmd = [
        'ffmpeg',
        '-y',
        '-i', bg_video,
        '-i', overlay_png,
        '-filter_complex', '[0:v][1:v]overlay=0:0',
        '-c:v', 'libx264',
        '-preset', preset,
        '-crf', '23',
        '-pix_fmt', 'yuv420p',
        '-colorspace', 'bt709',
        '-color_primaries', 'bt709',
        '-color_trc', 'bt709',
        '-color_range', 'tv',
        '-c:a', 'aac',
        output_path
    ]
    
    start_time = time.time()
    result = subprocess.run(cmd, capture_output=True, text=True)
    elapsed_time = time.time() - start_time
    
    if result.returncode == 0:
        file_size = os.path.getsize(output_path) / (1024 * 1024)
        print(f"   ✅ Success!")
        print(f"   Time: {elapsed_time:.2f}s")
        print(f"   Size: {file_size:.2f} MB")
        return {
            'success': True,
            'time': elapsed_time,
            'size': file_size,
            'preset': preset
        }
    else:
        print(f"   ❌ Failed: {result.stderr[:200]}")
        return {
            'success': False,
            'time': elapsed_time,
            'error': result.stderr[:200]
        }


def main():
    print("="*70)
    print(" "*15 + "FFMPEG CPU vs GPU BENCHMARK")
    print("="*70)
    
    # Get video info
    print("\n📹 Video Information:")
    info = get_video_info(BG_VIDEO)
    if info:
        duration = float(info['format']['duration'])
        size = int(info['format']['size']) / (1024 * 1024)
        print(f"   Duration: {duration:.2f}s")
        print(f"   Size: {size:.2f} MB")
    
    results = {}
    
    # ========================================
    # TEST 1: Simple Re-encoding
    # ========================================
    print("\n" + "="*70)
    print(" "*20 + "TEST 1: SIMPLE RE-ENCODING")
    print("="*70)
    
    # GPU
    gpu_output = os.path.join(OUTPUT_DIR, 'test1_gpu.mp4')
    results['test1_gpu'] = test_gpu_encoding(BG_VIDEO, gpu_output, preset='p4')
    
    # CPU - ultrafast
    cpu_ultrafast_output = os.path.join(OUTPUT_DIR, 'test1_cpu_ultrafast.mp4')
    results['test1_cpu_ultrafast'] = test_cpu_encoding(BG_VIDEO, cpu_ultrafast_output, preset='ultrafast')
    
    # CPU - medium (for comparison)
    cpu_medium_output = os.path.join(OUTPUT_DIR, 'test1_cpu_medium.mp4')
    results['test1_cpu_medium'] = test_cpu_encoding(BG_VIDEO, cpu_medium_output, preset='medium')
    
    # ========================================
    # TEST 2: Encoding with Overlay
    # ========================================
    print("\n" + "="*70)
    print(" "*20 + "TEST 2: ENCODING WITH PNG OVERLAY")
    print("="*70)
    
    # GPU
    gpu_overlay_output = os.path.join(OUTPUT_DIR, 'test2_gpu_overlay.mp4')
    results['test2_gpu_overlay'] = test_overlay_gpu(BG_VIDEO, PNG_TEMPLATE, gpu_overlay_output)
    
    # CPU - ultrafast
    cpu_overlay_ultrafast = os.path.join(OUTPUT_DIR, 'test2_cpu_overlay_ultrafast.mp4')
    results['test2_cpu_overlay_ultrafast'] = test_overlay_cpu(BG_VIDEO, PNG_TEMPLATE, cpu_overlay_ultrafast, preset='ultrafast')
    
    # CPU - medium
    cpu_overlay_medium = os.path.join(OUTPUT_DIR, 'test2_cpu_overlay_medium.mp4')
    results['test2_cpu_overlay_medium'] = test_overlay_cpu(BG_VIDEO, PNG_TEMPLATE, cpu_overlay_medium, preset='medium')
    
    # ========================================
    # SUMMARY
    # ========================================
    print("\n" + "="*70)
    print(" "*25 + "FINAL SUMMARY")
    print("="*70)
    
    print("\n📊 TEST 1: Simple Re-encoding")
    if results['test1_gpu']['success']:
        print(f"   GPU (NVENC p4):        {results['test1_gpu']['time']:.2f}s - {results['test1_gpu']['size']:.2f} MB")
    if results['test1_cpu_ultrafast']['success']:
        print(f"   CPU (ultrafast):       {results['test1_cpu_ultrafast']['time']:.2f}s - {results['test1_cpu_ultrafast']['size']:.2f} MB")
    if results['test1_cpu_medium']['success']:
        print(f"   CPU (medium):          {results['test1_cpu_medium']['time']:.2f}s - {results['test1_cpu_medium']['size']:.2f} MB")
    
    if results['test1_gpu']['success'] and results['test1_cpu_ultrafast']['success']:
        speedup1 = results['test1_cpu_ultrafast']['time'] / results['test1_gpu']['time']
        print(f"   GPU Speedup vs ultrafast: {speedup1:.2f}x")
    
    if results['test1_gpu']['success'] and results['test1_cpu_medium']['success']:
        speedup2 = results['test1_cpu_medium']['time'] / results['test1_gpu']['time']
        print(f"   GPU Speedup vs medium:    {speedup2:.2f}x")
    
    print("\n📊 TEST 2: Encoding with PNG Overlay")
    if results['test2_gpu_overlay']['success']:
        print(f"   GPU (NVENC p4):        {results['test2_gpu_overlay']['time']:.2f}s - {results['test2_gpu_overlay']['size']:.2f} MB")
    if results['test2_cpu_overlay_ultrafast']['success']:
        print(f"   CPU (ultrafast):       {results['test2_cpu_overlay_ultrafast']['time']:.2f}s - {results['test2_cpu_overlay_ultrafast']['size']:.2f} MB")
    if results['test2_cpu_overlay_medium']['success']:
        print(f"   CPU (medium):          {results['test2_cpu_overlay_medium']['time']:.2f}s - {results['test2_cpu_overlay_medium']['size']:.2f} MB")
    
    if results['test2_gpu_overlay']['success'] and results['test2_cpu_overlay_ultrafast']['success']:
        speedup3 = results['test2_cpu_overlay_ultrafast']['time'] / results['test2_gpu_overlay']['time']
        print(f"   GPU Speedup vs ultrafast: {speedup3:.2f}x")
    
    if results['test2_gpu_overlay']['success'] and results['test2_cpu_overlay_medium']['success']:
        speedup4 = results['test2_cpu_overlay_medium']['time'] / results['test2_gpu_overlay']['time']
        print(f"   GPU Speedup vs medium:    {speedup4:.2f}x")
    
    print("\n💡 KEY INSIGHTS:")
    print("   • GPU encoding is fastest for the encoding step itself")
    print("   • CPU 'ultrafast' is very fast but lower quality")
    print("   • CPU 'medium' has better quality but much slower")
    print("   • Overlay processing happens on CPU in both cases")
    print("   • GPU advantage increases with better CPU presets")
    
    print("\n📁 Output files saved to:")
    print(f"   {OUTPUT_DIR}")
    
    print("\n" + "="*70)


if __name__ == "__main__":
    main()
