# Fork Setup Guide - Komikku with PDF Support

This guide will help you set up your fork to build APKs automatically.

## What's Already Done ✓

- ✓ PDF support added to the app
- ✓ Firebase dependencies removed from workflows
- ✓ Dummy config files created
- ✓ Workflows configured for minimal setup

## Setup Your Fork (3 Simple Steps)

### Step 1: Generate Signing Key

Run the keystore generation script:

```bash
cd scripts
./generate-keystore.sh
```

Follow the prompts to create your keystore. The script will:
- Generate a keystore file
- Create a base64-encoded version for GitHub
- Display the values you need

**⚠️ IMPORTANT:** Keep the generated files secure and add them to `.gitignore`!

### Step 2: Add GitHub Secrets

Go to your fork: `Settings → Secrets and variables → Actions`

Click **"New repository secret"** and add these 4 secrets:

| Secret Name | Value |
|------------|-------|
| `SIGNING_KEY` | Content from `signing_key_base64.txt` |
| `ALIAS` | The alias you chose (e.g., `komikku-key`) |
| `KEY_STORE_PASSWORD` | Your keystore password |
| `KEY_PASSWORD` | Your key password |

### Step 3: Push Your Changes

```bash
git add .
git commit -m "Add PDF support and configure for fork"
git push origin master
```

## Building APKs

### Option 1: Automatic CI Build (on every push)
Just push to master branch:
```bash
git push origin master
```
- APK will be available in **Actions** tab as an artifact
- No release created

### Option 2: Preview Release (manual trigger)
1. Go to **Actions** tab
2. Select **"Preview Builder"** workflow
3. Click **"Run workflow"**
4. APKs will be created as a **draft prerelease**

### Option 3: Full Release (tag-based)
```bash
git tag v1.0.0
git push origin v1.0.0
```
- APKs will be created as a **draft release**
- Edit the release notes and publish when ready

## What's Included in Builds

All workflows now build these APK variants:
- **Universal** (works on all devices)
- **arm64-v8a** (modern 64-bit ARM)
- **armeabi-v7a** (older 32-bit ARM)
- **x86** (Intel 32-bit)
- **x86_64** (Intel 64-bit)

## Testing Your PDF Support

1. Build and install the APK
2. Create a folder: `[Your Phone]/Komikku/local/TestManga/`
3. Add PDF files as chapters:
   ```
   local/
     TestManga/
       Chapter 1.pdf
       Chapter 2.pdf
   ```
4. Open Komikku and browse Local source
5. Your manga should appear with PDF chapters working!

## Troubleshooting

### Build fails with "signing key not found"
- Make sure you added all 4 secrets to GitHub
- Check that the base64 encoding is correct (no extra spaces/newlines)

### Build fails with Firebase errors
- The dummy config files should prevent this
- If it still fails, check that `google-services.json` exists in `/app/`

### APKs not created
- Check the Actions tab for error logs
- Ensure you have Actions enabled in your fork settings

## Optional: Re-enable Firebase (if needed)

If you want to add Firebase Analytics/Crashlytics:

1. Get your real `google-services.json` from Firebase Console
2. Get your `client_secrets.json` for Google Drive
3. Add them as GitHub secrets:
   - `GOOGLE_SERVICES_JSON`
   - `GOOGLE_CLIENT_SECRETS_JSON`
4. Restore the "Write google-services.json" steps in workflows
5. Add `-Pinclude-telemetry` back to build commands

## Need Help?

- Check the [original Komikku documentation](https://komikku-app.github.io/)
- Review the workflow logs in the Actions tab
- Ensure all secrets are properly configured

---

**Your fork is now ready to build! 🎉**
