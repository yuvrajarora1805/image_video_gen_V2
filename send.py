import requests
import time

GRAPH_API_VERSION = "v19.0"
BASE_URL = f"https://graph.facebook.com/{GRAPH_API_VERSION}"

# =====================================================
# 🔐 TOKENS (ADDED)
# =====================================================

# Instagram (System User Token – EAAG)
SYSTEM_ACCESS_TOKEN = "EAAQUNIp1XZAsBQQDOuC7no0WrfBKWsEWXsw1aWxC9TZAyJNklIx7brbtGK4NKDh1KrBMRqUgtgnmPK361OapNd9kq05KUAkN0u7ZAU4TXjZCygtkT2wPhdsx2NKP9dXXXJpB0Vb3xZBupfe1JfedGOdlUZBOfe1KmiJrxeKjZCN773i0GJeBTrdrzDmQVhRlgZCxz2ZCeuJJvcvCZBLhfHGscZCkrNFGXZBqohhZBNL67"

# Facebook Page Token – EAAQ
PAGE_ACCESS_TOKEN = "EAAQUNIp1XZAsBQSrhYaIF18P9ZAQK4sJXkqXfS8R22u6peBZCiYYfLImo2YK3tasmGdNmkFvnKsqW2PwIfWUhl1ZCKlxpUvEvqEcr8G4yw3Kz6HZAND57Wo9AheZBJMQFRjyJ8aLqdbqgYZCB8f9E5ZA3wMQZCg9kv1nBZBRZB9iH9UQiqg241wr6MHAzuYDLC86CZA7mZBsG"

# =====================================================
# 🆔 IDS
# =====================================================

IG_USER_ID = "17841478123611469"
PAGE_ID = "921733587691767"

# =====================================================
# 🎥 CONTENT
# =====================================================

VIDEO_URL = "https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4"

CAPTION = """🚀 New Reel from Yaspik Tech!

Uploaded automatically using Meta Graph API.

#yaspiktech #automation #reels #facebook #instagram
"""

# =====================================================
# 📸 INSTAGRAM FUNCTIONS
# =====================================================

def create_instagram_reel_container():
    url = f"{BASE_URL}/{IG_USER_ID}/media"
    payload = {
        "media_type": "REELS",
        "video_url": VIDEO_URL,
        "caption": CAPTION,
        "access_token": SYSTEM_ACCESS_TOKEN
    }

    r = requests.post(url, data=payload)
    r.raise_for_status()

    media_id = r.json()["id"]
    print(f"[IG] Media container created: {media_id}")
    return media_id


def wait_for_instagram_processing(media_id):
    print("[IG] Waiting for video processing...")
    while True:
        r = requests.get(
            f"{BASE_URL}/{media_id}",
            params={
                "fields": "status_code",
                "access_token": SYSTEM_ACCESS_TOKEN
            }
        )
        r.raise_for_status()

        status = r.json().get("status_code")
        print(f"[IG] Status: {status}")

        if status == "FINISHED":
            print("[IG] Processing complete")
            return
        elif status == "ERROR":
            raise Exception("Instagram video processing failed")

        time.sleep(10)


def publish_instagram_reel(media_id):
    r = requests.post(
        f"{BASE_URL}/{IG_USER_ID}/media_publish",
        data={
            "creation_id": media_id,
            "access_token": SYSTEM_ACCESS_TOKEN
        }
    )
    r.raise_for_status()

    print(f"[IG] Reel published successfully! Post ID: {r.json()['id']}")

# =====================================================
# 📘 FACEBOOK FUNCTION (REELS – STABLE METHOD)
# =====================================================

def upload_facebook_reel():
    url = f"{BASE_URL}/{PAGE_ID}/videos"
    payload = {
        "file_url": VIDEO_URL,
        "description": CAPTION,
        "is_reel": "true",
        "access_token": PAGE_ACCESS_TOKEN
    }

    r = requests.post(url, data=payload)
    r.raise_for_status()

    print(f"[FB] Reel published successfully! Video ID: {r.json()['id']}")

# =====================================================
# 🚀 MAIN
# =====================================================

if __name__ == "__main__":
    try:
        ig_media_id = create_instagram_reel_container()
        wait_for_instagram_processing(ig_media_id)
        publish_instagram_reel(ig_media_id)

        upload_facebook_reel()

        print("\nSUCCESS: Posted to BOTH Instagram & Facebook Reels")

    except Exception as e:
        print("\nERROR:", e)
