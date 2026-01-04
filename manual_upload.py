#!/usr/bin/env python3
"""
Manual Facebook/Instagram Video Uploader
Checks permissions and uploads video for a specific credential
"""

import requests
import json
import sys
import time
import os

def check_permissions(access_token):
    """Check if token has required permissions"""
    print("\n" + "="*60)
    print("STEP 1: Checking Token Permissions")
    print("="*60)
    
    url = f"https://graph.facebook.com/v21.0/me/permissions?access_token={access_token}"
    
    try:
        response = requests.get(url)
        if response.status_code != 200:
            print(f"❌ Error checking permissions: HTTP {response.status_code}")
            return False, []
        
        data = response.json()
        granted = []
        
        if 'data' in data:
            for perm in data['data']:
                if perm['status'] == 'granted':
                    granted.append(perm['permission'])
        
        required = ['pages_manage_posts', 'pages_read_engagement', 'instagram_content_publish']
        missing = [p for p in required if p not in granted]
        
        print(f"\n✅ Granted permissions: {len(granted)}")
        for p in granted:
            print(f"   • {p}")
        
        if missing:
            print(f"\n❌ Missing required permissions:")
            for p in missing:
                print(f"   • {p}")
            return False, granted
        
        print("\n✅ All required permissions granted!")
        return True, granted
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False, []

def upload_to_facebook(access_token, page_id, video_url, caption=""):
    """Upload video to Facebook Page"""
    print("\n" + "="*60)
    print("STEP 2: Uploading to Facebook")
    print("="*60)
    
    url = f"https://graph.facebook.com/v21.0/{page_id}/videos"
    
    params = {
        'access_token': access_token,
        'file_url': video_url,
        'description': caption
    }
    
    print(f"\n📤 Uploading video...")
    print(f"   Page ID: {page_id}")
    print(f"   Video URL: {video_url}")
    print(f"   Caption: {caption}")
    
    try:
        response = requests.post(url, data=params)
        result = response.json()
        
        if response.status_code == 200 and 'id' in result:
            print(f"\n✅ Facebook upload successful!")
            print(f"   Video ID: {result['id']}")
            return True, result
        else:
            print(f"\n❌ Facebook upload failed!")
            print(f"   Status: {response.status_code}")
            print(f"   Response: {json.dumps(result, indent=2)}")
            return False, result
            
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        return False, {}

def upload_to_instagram(access_token, ig_user_id, video_url, caption=""):
    """Upload video to Instagram"""
    print("\n" + "="*60)
    print("STEP 3: Uploading to Instagram")
    print("="*60)
    
    # Step 1: Create media container
    print(f"\n📤 Creating Instagram media container...")
    container_url = f"https://graph.facebook.com/v21.0/{ig_user_id}/media"
    
    container_params = {
        'access_token': access_token,
        'media_type': 'REELS',
        'video_url': video_url,
        'caption': caption
    }
    
    try:
        response = requests.post(container_url, data=container_params)
        result = response.json()
        
        if response.status_code != 200 or 'id' not in result:
            print(f"❌ Failed to create media container!")
            print(f"   Response: {json.dumps(result, indent=2)}")
            return False, result
        
        container_id = result['id']
        print(f"✅ Media container created: {container_id}")
        
        # Step 2: Check container status
        print(f"\n⏳ Waiting for Instagram to process video...")
        max_attempts = 30
        
        for attempt in range(max_attempts):
            time.sleep(2)
            status_url = f"https://graph.facebook.com/v21.0/{container_id}"
            status_params = {
                'access_token': access_token,
                'fields': 'status_code,status'
            }
            
            status_response = requests.get(status_url, params=status_params)
            status_result = status_response.json()
            
            status_code = status_result.get('status_code')
            print(f"   Attempt {attempt + 1}/{max_attempts}: Status = {status_code}")
            
            if status_code == 'FINISHED':
                print(f"✅ Video processed successfully!")
                break
            elif status_code == 'ERROR':
                print(f"❌ Instagram failed to process video!")
                print(f"   Error: {status_result.get('status')}")
                return False, status_result
            elif attempt == max_attempts - 1:
                print(f"❌ Timeout waiting for video processing")
                return False, status_result
        
        # Step 3: Publish the container
        print(f"\n📤 Publishing to Instagram...")
        publish_url = f"https://graph.facebook.com/v21.0/{ig_user_id}/media_publish"
        publish_params = {
            'access_token': access_token,
            'creation_id': container_id
        }
        
        publish_response = requests.post(publish_url, data=publish_params)
        publish_result = publish_response.json()
        
        if publish_response.status_code == 200 and 'id' in publish_result:
            print(f"✅ Instagram upload successful!")
            print(f"   Post ID: {publish_result['id']}")
            return True, publish_result
        else:
            print(f"❌ Instagram publish failed!")
            print(f"   Response: {json.dumps(publish_result, indent=2)}")
            return False, publish_result
            
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False, {}

def main():
    print("\n" + "="*60)
    print("MANUAL VIDEO UPLOADER FOR TESTTEST")
    print("="*60)
    
    # Configuration - UPDATE THESE VALUES
    ACCESS_TOKEN = input("\nEnter Access Token: ").strip()
    PAGE_ID = input("Enter Facebook Page ID: ").strip()
    IG_USER_ID = input("Enter Instagram User ID: ").strip()
    VIDEO_URL = input("Enter Video URL: ").strip()
    CAPTION = input("Enter Caption (optional): ").strip()
    PLATFORM = input("Upload to (facebook/instagram/both): ").strip().lower()
    
    if not all([ACCESS_TOKEN, VIDEO_URL]):
        print("\n❌ Error: Access token and video URL are required!")
        sys.exit(1)
    
    # Check permissions
    has_permissions, granted = check_permissions(ACCESS_TOKEN)
    
    if not has_permissions:
        print("\n⚠️  WARNING: Missing required permissions!")
        proceed = input("\nDo you want to try uploading anyway? (yes/no): ").strip().lower()
        if proceed != 'yes':
            print("\n❌ Upload cancelled. Please add the required permissions first.")
            sys.exit(1)
    
    # Upload based on platform
    fb_success = False
    ig_success = False
    
    if PLATFORM in ['facebook', 'both']:
        if not PAGE_ID:
            print("\n❌ Error: Facebook Page ID required for Facebook upload!")
        else:
            fb_success, fb_result = upload_to_facebook(ACCESS_TOKEN, PAGE_ID, VIDEO_URL, CAPTION)
    
    if PLATFORM in ['instagram', 'both']:
        if not IG_USER_ID:
            print("\n❌ Error: Instagram User ID required for Instagram upload!")
        else:
            ig_success, ig_result = upload_to_instagram(ACCESS_TOKEN, IG_USER_ID, VIDEO_URL, CAPTION)
    
    # Summary
    print("\n" + "="*60)
    print("UPLOAD SUMMARY")
    print("="*60)
    
    if PLATFORM in ['facebook', 'both']:
        print(f"Facebook: {'✅ Success' if fb_success else '❌ Failed'}")
    
    if PLATFORM in ['instagram', 'both']:
        print(f"Instagram: {'✅ Success' if ig_success else '❌ Failed'}")
    
    print("="*60 + "\n")
    
    sys.exit(0 if (fb_success or ig_success) else 1)

if __name__ == "__main__":
    main()
