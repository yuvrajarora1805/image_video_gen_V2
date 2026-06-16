import requests
import time
import sys
import json
import argparse

import logging
import os

GRAPH_API_VERSION = "v25.0"
BASE_URL = f"https://graph.facebook.com/{GRAPH_API_VERSION}"

# Setup logging
# storage/logs is in the same directory as this script
log_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "storage", "logs")
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(
    filename=os.path.join(log_dir, "facebook_uploader.log"),
    level=logging.INFO,
    format='%(asctime)s - [%(levelname)s] - %(message)s'
)

def log_print(msg, level="info"):
    """Log mechanism that prints to stderr and writes to file"""
    print(msg, file=sys.stderr)
    if level == "error":
        logging.error(msg)
    else:
        logging.info(msg)


def upload_facebook_reel(page_id, video_url, caption, access_token):
    """Upload video as Reel to Facebook Page."""
    url = f"{BASE_URL}/{page_id}/videos"
    
    payload = {
        "file_url": video_url,
        "description": caption,
        "is_reel": "true",
        "access_token": access_token
    }
    
    log_print(f"[FB] Uploading reel to Facebook Page {page_id}...")
    
    try:
        response = requests.post(url, data=payload)
        response.raise_for_status()
        
        result = response.json()
        video_id = result.get("id")
        
        log_print(f"[FB] Reel published successfully! Video ID: {video_id}")
        return video_id
    except requests.exceptions.HTTPError as e:
        error_msg = f"HTTP Error: {e.response.status_code} - {e.response.text}"
        log_print(f"[ERROR] Facebook API Error: {error_msg}", "error")
        raise Exception(error_msg)
    except Exception as e:
        log_print(f"[ERROR] FB Upload Error: {str(e)}", "error")
        raise e


def update_laravel_status(callback_url, log_id, status, video_id=None, error=None):
    """Update Laravel database via HTTP callback."""
    try:
        payload = {
            'log_id': log_id,
            'status': status,
            'media_container_id': video_id,
            'post_id': video_id,
            'error_message': error
        }
        response = requests.post(callback_url, json=payload, timeout=10)
        response.raise_for_status()
        log_print(f"[✓] Laravel status updated: {status}")
    except Exception as e:
        log_print(f"[⚠] Failed to update Laravel: {e}", "error")


def main():
    # Force UTF-8 output for Windows console
    if sys.stdout.encoding != 'utf-8':
        sys.stdout.reconfigure(encoding='utf-8')
    if sys.stderr.encoding != 'utf-8':
        sys.stderr.reconfigure(encoding='utf-8')

    parser = argparse.ArgumentParser(description='Upload video to Facebook Page as Reel')
    parser.add_argument('--access-token', required=True, help='Facebook Page Access Token')
    parser.add_argument('--page-id', required=True, help='Facebook Page ID')
    parser.add_argument('--video-url', required=True, help='Public URL of the video')
    parser.add_argument('--caption', default='', help='Caption for the reel')
    parser.add_argument('--log-id', required=True, help='Upload log ID for tracking')
    parser.add_argument('--callback-url', required=True, help='Laravel callback URL to update status')
    
    args = parser.parse_args()

    result = {
        'success': False,
        'video_id': None,
        'error': None,
        'log_id': args.log_id
    }

    try:
        # Upload video as Reel to Facebook
        video_id = upload_facebook_reel(
            args.page_id,
            args.video_url,
            args.caption,
            args.access_token
        )
        result['video_id'] = video_id
        result['success'] = True

        # Update Laravel - Published
        update_laravel_status(
            args.callback_url,
            args.log_id,
            'published',
            video_id
        )

    except requests.exceptions.HTTPError as e:
        error_msg = f"HTTP Error: {e.response.status_code} - {e.response.text}"
        result['error'] = error_msg
        log_print(f"[❌ ERROR] {error_msg}", "error")
        
        # Update Laravel - Failed
        update_laravel_status(
            args.callback_url,
            args.log_id,
            'failed',
            None,
            error_msg
        )
        
    except Exception as e:
        result['error'] = str(e)
        log_print(f"[❌ ERROR] {e}", "error")
        
        # Update Laravel - Failed
        update_laravel_status(
            args.callback_url,
            args.log_id,
            'failed',
            None,
            str(e)
        )

    # Output JSON result to stdout for Laravel to parse
    # print(json.dumps(result)) # Commented out to keep log clean
    
    if result['success']:
        log_print("\n🎉 SUCCESS: Posted to Facebook Reels")
    else:
        log_print(f"\n❌ ERROR: {result.get('error')}")
    
    # Exit with appropriate code
    sys.exit(0 if result['success'] else 1)


if __name__ == "__main__":
    main()
