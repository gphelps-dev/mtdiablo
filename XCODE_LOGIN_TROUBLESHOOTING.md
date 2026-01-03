# Xcode Login Troubleshooting Guide

## The Error
```
Unable to log in with account 'gary.mphelps@gmail.com'. 
The login details for account 'gary.mphelps@gmail.com' were rejected.
```

## Quick Fixes (Try in Order)

### 1. Sign Out and Sign Back In

**In Xcode:**
1. Open Xcode → **Settings** (or **Preferences**)
2. Go to **Accounts** tab
3. Select your account (`gary.mphelps@gmail.com`)
4. Click the **"-"** button to remove it
5. Click **"+"** to add it back
6. Enter your Apple ID credentials

### 2. Use App-Specific Password (If 2FA is Enabled)

If you have two-factor authentication enabled:

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in with your Apple ID
3. Go to **Security** → **App-Specific Passwords**
4. Generate a new app-specific password
5. In Xcode → Settings → Accounts, use this password instead of your regular password

### 3. Check Apple ID Status

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Verify your account is active and in good standing
3. Check if you need to verify your email or update payment info

### 4. Clear Xcode Keychain

**Warning:** This will remove saved passwords. You'll need to re-enter them.

```bash
# Remove Xcode's keychain entries
security delete-internet-password -s idmsa.apple.com 2>/dev/null
security delete-generic-password -a "Xcode" 2>/dev/null
```

Then restart Xcode and try signing in again.

### 5. Check Network/Firewall

- Ensure you can access appleid.apple.com
- Check if a VPN or firewall is blocking connections
- Try disabling VPN temporarily

### 6. Update Xcode

Sometimes older Xcode versions have authentication issues:

1. Check for Xcode updates: **Xcode → Check for Updates**
2. Or update via App Store

### 7. Use Command Line to Sign In

Try signing in via command line:

```bash
# This will prompt for your Apple ID credentials
xcrun altool --list-providers
```

### 8. Check Developer Account Status

If you're trying to use a Developer ID certificate:

1. Go to [developer.apple.com](https://developer.apple.com)
2. Sign in with your Apple ID
3. Verify your membership is active (if you have a paid membership)
4. Check that your certificates are valid

### 9. For Xcode Cloud / CI/CD

If this is for Xcode Cloud builds:

1. In Xcode Cloud, go to your workflow settings
2. Check the **"Signing & Capabilities"** section
3. Ensure the correct team is selected
4. Xcode Cloud uses its own signing - you don't need to sign in locally for Cloud builds

## Common Causes

1. **Expired Password**: Your Apple ID password may have expired
2. **2FA Required**: You need to use an app-specific password
3. **Account Locked**: Your account may be temporarily locked due to failed login attempts
4. **Network Issues**: Firewall or VPN blocking Apple's authentication servers
5. **Xcode Bug**: Sometimes Xcode's keychain gets corrupted

## For Your Current Issue

Since you're trying to archive for distribution:

1. **Try signing out and back in** (most common fix)
2. **Use an app-specific password** if you have 2FA enabled
3. **Check your Developer account** at developer.apple.com

If you just need to test locally, you can use **"Sign to Run Locally"** (ad-hoc signing) which doesn't require login. But for App Store distribution, you'll need proper code signing.

## Alternative: Use Automatic Signing

If manual signing is causing issues:

1. In Xcode, select your **Runner** target
2. Go to **Signing & Capabilities**
3. Check **"Automatically manage signing"**
4. Select your **Team** from the dropdown
5. Xcode will handle certificate management automatically



