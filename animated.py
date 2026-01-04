from moviepy import *
import numpy as np
from PIL import Image

# Paths
BG_VIDEO = "D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\testvideo.mp4"
TEMPLATE = "D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1765479311_693b138fee554.png"
OUTPUT = "final_output.mp4"

# Load background video (no effects applied)
bg = VideoFileClip(BG_VIDEO)

duration = bg.duration
video_width, video_height = bg.size

# Load and resize template
template_pil = Image.open(TEMPLATE).convert("RGBA")
scale_factor = video_height / template_pil.height
new_width = int(template_pil.width * scale_factor)
new_height = video_height
template_resized = template_pil.resize((new_width, new_height), Image.LANCZOS)

# Convert to numpy array
template_array = np.array(template_resized)

# Wipe-in animation with cloudy soft edge effect
def wipe_in_animation(t):
    wipe_duration = 6.5  # Slower wipe - 6.5 seconds
    
    if t >= wipe_duration:
        # Fully revealed
        return template_array
    
    # During wipe
    progress = t / wipe_duration
    eased_progress = 1 - pow(1 - progress, 3)  # Cubic ease-out
    
    # Create a copy
    result = template_array.copy()
    
    # Calculate reveal position
    reveal_width = int(result.shape[1] * eased_progress)
    
    # Create cloudy/feathered edge effect
    feather_width = 80  # Width of the soft edge in pixels
    
    if reveal_width < result.shape[1]:
        # Hard cut for already revealed area
        result[:, reveal_width + feather_width:, 3] = 0
        
        # Create soft cloudy transition
        if reveal_width < result.shape[1] - feather_width:
            for i in range(feather_width):
                x_pos = reveal_width + i
                if x_pos < result.shape[1]:
                    # Create smooth gradient with noise for cloudy effect
                    alpha_factor = (feather_width - i) / feather_width
                    # Add noise for cloudy appearance
                    noise = np.random.rand(result.shape[0]) * 0.3
                    alpha_multiplier = alpha_factor + noise
                    alpha_multiplier = np.clip(alpha_multiplier, 0, 1)
                    result[:, x_pos, 3] = (result[:, x_pos, 3] * alpha_multiplier).astype(np.uint8)
    
    return result

# Create template clip with wipe-in animation
overlay = (
    VideoClip(lambda t: wipe_in_animation(t), duration=duration)
    .with_position(('center', 'center'))
)

# Composite - background stays untouched
final = CompositeVideoClip([bg, overlay], size=(video_width, video_height))

# Export
final.write_videofile(
    OUTPUT,
    fps=30,
    codec="libx264",
    audio_codec="aac"
)

