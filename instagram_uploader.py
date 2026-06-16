import requests
import time
import sys
import json
import argparse
import logging
import os

GRAPH_API_VERSION = "v25.0"
BASE_URL = f"https://graph.facebook.com/{GRAPH_API_VERSION}"

# =====================================================
# Logging Setup
# =====================================================
log_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "storage", "logs")
os.makedirs(log_dir, exist_ok=True)

logging.basicConfig(
    filename=os.path.join(log_dir, "instagram_uploader.log"),
    level=logging.INFO,
    format='%(asctime)s - [%(levelname)s] - %(message)s'
)

def log_print(msg, level="info"):
    print(msg, file=sys.stderr)
    if level == "error":
        logging.error(msg)
    else:
        logging.info(msg)

# =====================================================
# Instagram API Functions
# =====================================================
def create_reel_container(ig_user_id, video_url, caption, access_token):
    url = f"{BASE_URL}/{ig_user_id}/media"

    payload = {
        "media_type": "REELS",
        "video_url": video_url,
        "caption": caption,
        "access_token": access_token
    }

    response = requests.post(url, data=payload)
    response.raise_for_status()

    media_id = response.json().get("id")
    if not media_id:
        raise Exception(f"Invalid media container response: {response.text}")

    log_print(f"[IG] Media container created: {media_id}")
    return media_id


def wait_for_processing(media_id, access_token, max_attempts=30):
    log_print("[IG] Waiting for video processing...")

    status_url = f"{BASE_URL}/{media_id}"
    params = {
        "fields": "status_code,status,error_message",
        "access_token": access_token
    }

    attempt = 0
    while attempt < max_attempts:
        try:
            res = requests.get(status_url, params=params)
            res.raise_for_status()
            data = res.json()

            status = data.get("status_code")
            error_msg = data.get("error_message")
            log_print(f"[IG] Status: {status}")

            if status == "FINISHED":
                log_print("[IG] Processing complete")
                return

            if status == "ERROR":
                detailed_error = error_msg if error_msg else "Unknown Instagram processing error"
                log_print(f"[ERROR] Instagram Video Error: {detailed_error}", "error")
                raise Exception(detailed_error)

            attempt += 1
            time.sleep(10)
        except Exception as e:
            if "status_code" in str(e): # re-raise if it's our own exception
                raise e
            log_print(f"[⚠] Status check attempt {attempt+1} failed: {e}", "info")
            attempt += 1
            time.sleep(10)

    raise TimeoutError("Instagram processing timed out")


def publish_reel(ig_user_id, media_id, access_token):
    url = f"{BASE_URL}/{ig_user_id}/media_publish"

    payload = {
        "creation_id": media_id,
        "access_token": access_token
    }

    response = requests.post(url, data=payload)
    response.raise_for_status()

    post_id = response.json().get("id")
    if not post_id:
        raise Exception(f"Invalid publish response: {response.text}")

    log_print(f"[IG] Reel published successfully! Post ID: {post_id}")
    return post_id


def update_laravel_status(callback_url, log_id, status, media_container_id=None, post_id=None, error=None):
    try:
        payload = {
            "log_id": log_id,
            "status": status,
            "media_container_id": media_container_id,
            "post_id": post_id,
            "error_message": error
        }

        response = requests.post(callback_url, json=payload, timeout=10)
        response.raise_for_status()

        log_print(f"[✓] Laravel status updated: {status}")
    except Exception as e:
        log_print(f"[⚠] Laravel update failed: {e}", "error")

# =====================================================
# Main
# =====================================================
def main():
    if sys.stdout.encoding != 'utf-8':
        sys.stdout.reconfigure(encoding='utf-8')
    if sys.stderr.encoding != 'utf-8':
        sys.stderr.reconfigure(encoding='utf-8')

    parser = argparse.ArgumentParser(description="Upload Instagram Reel")
    parser.add_argument("--access-token", required=True)
    parser.add_argument("--ig-user-id", required=True)
    parser.add_argument("--video-url", required=True)
    parser.add_argument("--caption", default="")
    parser.add_argument("--log-id", required=True)
    parser.add_argument("--callback-url", required=True)

    args = parser.parse_args()

    result = {
        "success": False,
        "media_container_id": None,
        "post_id": None,
        "error": None
    }

    try:
        media_container_id = create_reel_container(
            args.ig_user_id,
            args.video_url,
            args.caption,
            args.access_token
        )
        result["media_container_id"] = media_container_id

        update_laravel_status(
            args.callback_url,
            args.log_id,
            "processing",
            media_container_id
        )

        wait_for_processing(media_container_id, args.access_token)

        post_id = publish_reel(args.ig_user_id, media_container_id, args.access_token)
        result["post_id"] = post_id
        result["success"] = True

        update_laravel_status(
            args.callback_url,
            args.log_id,
            "published",
            media_container_id,
            post_id
        )

        log_print("\n🎉 SUCCESS: Reel published")

    except requests.exceptions.HTTPError as e:
        error_msg = f"HTTP Error {e.response.status_code}: {e.response.text}"
        result["error"] = error_msg
        log_print(error_msg, "error")

        update_laravel_status(
            args.callback_url,
            args.log_id,
            "failed",
            result["media_container_id"],
            None,
            error_msg
        )

    except Exception as e:
        result["error"] = str(e)
        log_print(str(e), "error")

        update_laravel_status(
            args.callback_url,
            args.log_id,
            "failed",
            result["media_container_id"],
            None,
            str(e)
        )

    sys.exit(0 if result["success"] else 1)


if __name__ == "__main__":
    main()
