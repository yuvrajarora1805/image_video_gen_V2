#!/usr/bin/env python3
"""
Facebook Token Permission Checker
Checks what permissions a Facebook access token has
"""

import requests
import json
import sys

def check_token_permissions(access_token):
    """
    Check permissions for a Facebook access token
    """
    print("=" * 60)
    print("Facebook Token Permission Checker")
    print("=" * 60)
    print()
    
    # Query Facebook Graph API
    url = f"https://graph.facebook.com/v21.0/me/permissions?access_token={access_token}"
    
    try:
        response = requests.get(url)
        
        if response.status_code != 200:
            print(f"❌ Error: HTTP {response.status_code}")
            print(response.text)
            return False
        
        data = response.json()
        
        # Required permissions for video upload
        required_permissions = {
            'pages_manage_posts': 'Required to post videos to Facebook Pages',
            'pages_read_engagement': 'Required to read page engagement data',
            'pages_show_list': 'Required to list pages',
            'instagram_basic': 'Required for Instagram access',
            'instagram_content_publish': 'Required to publish to Instagram'
        }
        
        # Get granted permissions
        granted_permissions = []
        if 'data' in data:
            for perm in data['data']:
                if perm['status'] == 'granted':
                    granted_permissions.append(perm['permission'])
        
        # Find missing permissions
        missing_permissions = []
        for perm in required_permissions.keys():
            if perm not in granted_permissions:
                missing_permissions.append(perm)
        
        # Display results
        print(f"✅ GRANTED PERMISSIONS ({len(granted_permissions)}):")
        print("-" * 60)
        for perm in granted_permissions:
            marker = "✓" if perm in required_permissions else " "
            description = required_permissions.get(perm, "")
            print(f"  [{marker}] {perm}")
            if description:
                print(f"      → {description}")
        
        print()
        
        if missing_permissions:
            print(f"❌ MISSING REQUIRED PERMISSIONS ({len(missing_permissions)}):")
            print("-" * 60)
            for perm in missing_permissions:
                print(f"  [✗] {perm}")
                print(f"      → {required_permissions[perm]}")
            print()
            print("⚠️  WARNING: This token will NOT work for video uploads!")
            print()
            print("HOW TO FIX:")
            print("1. Go to: https://developers.facebook.com/tools/explorer")
            print("2. Select your app")
            print("3. Add these missing permissions:")
            for perm in missing_permissions:
                print(f"   - {perm}")
            print("4. Click 'Generate Access Token'")
            print("5. Update your credential with the new token")
        else:
            print("✅ ALL REQUIRED PERMISSIONS GRANTED!")
            print("   This token should work for video uploads.")
        
        print()
        print("=" * 60)
        
        return len(missing_permissions) == 0
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

if __name__ == "__main__":
    print()
    print("Enter your Facebook Access Token:")
    print("(You can find this in your Instagram credentials)")
    print()
    
    if len(sys.argv) > 1:
        access_token = sys.argv[1]
    else:
        access_token = input("Access Token: ").strip()
    
    if not access_token:
        print("❌ Error: No access token provided")
        sys.exit(1)
    
    print()
    success = check_token_permissions(access_token)
    
    sys.exit(0 if success else 1)
