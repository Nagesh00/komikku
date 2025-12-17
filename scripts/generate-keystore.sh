#!/bin/bash
# Script to generate Android keystore and GitHub secrets

set -e

echo "=================================="
echo "Android Keystore Generator"
echo "=================================="
echo ""

# Default values
DEFAULT_ALIAS="komikku-key"
DEFAULT_VALIDITY=10000
DEFAULT_KEYSTORE="komikku-release.jks"

# Prompt for values
read -p "Enter key alias [${DEFAULT_ALIAS}]: " ALIAS
ALIAS=${ALIAS:-$DEFAULT_ALIAS}

read -sp "Enter keystore password: " KEYSTORE_PASSWORD
echo ""
read -sp "Confirm keystore password: " KEYSTORE_PASSWORD_CONFIRM
echo ""

if [ "$KEYSTORE_PASSWORD" != "$KEYSTORE_PASSWORD_CONFIRM" ]; then
    echo "Passwords don't match!"
    exit 1
fi

read -sp "Enter key password: " KEY_PASSWORD
echo ""
read -sp "Confirm key password: " KEY_PASSWORD_CONFIRM
echo ""

if [ "$KEY_PASSWORD" != "$KEY_PASSWORD_CONFIRM" ]; then
    echo "Passwords don't match!"
    exit 1
fi

read -p "Enter keystore filename [${DEFAULT_KEYSTORE}]: " KEYSTORE_FILE
KEYSTORE_FILE=${KEYSTORE_FILE:-$DEFAULT_KEYSTORE}

echo ""
echo "Generating keystore..."
echo ""

# Generate keystore
keytool -genkey -v \
    -keystore "$KEYSTORE_FILE" \
    -alias "$ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity $DEFAULT_VALIDITY \
    -storepass "$KEYSTORE_PASSWORD" \
    -keypass "$KEY_PASSWORD"

echo ""
echo "=================================="
echo "Keystore generated successfully!"
echo "=================================="
echo ""
echo "File: $KEYSTORE_FILE"
echo "Alias: $ALIAS"
echo ""
echo "Converting to base64 for GitHub secrets..."
echo ""

# Convert to base64
if command -v base64 &> /dev/null; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        BASE64_KEY=$(base64 -i "$KEYSTORE_FILE")
    else
        # Linux
        BASE64_KEY=$(base64 -w 0 "$KEYSTORE_FILE")
    fi
    
    echo "=================================="
    echo "GitHub Secrets Configuration"
    echo "=================================="
    echo ""
    echo "Go to your GitHub repository:"
    echo "Settings → Secrets and variables → Actions → New repository secret"
    echo ""
    echo "Add these 4 secrets:"
    echo ""
    echo "1. SIGNING_KEY"
    echo "   Value: (see signing_key_base64.txt)"
    echo ""
    echo "2. ALIAS"
    echo "   Value: $ALIAS"
    echo ""
    echo "3. KEY_STORE_PASSWORD"
    echo "   Value: $KEYSTORE_PASSWORD"
    echo ""
    echo "4. KEY_PASSWORD"
    echo "   Value: $KEY_PASSWORD"
    echo ""
    
    # Save base64 to file
    echo "$BASE64_KEY" > signing_key_base64.txt
    echo "✓ Base64 key saved to: signing_key_base64.txt"
    echo ""
    echo "⚠️  IMPORTANT: Keep $KEYSTORE_FILE and signing_key_base64.txt SECURE!"
    echo "⚠️  Add them to .gitignore to prevent accidental commits!"
    echo ""
else
    echo "base64 command not found. Please install it first."
    exit 1
fi

echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Add the 4 secrets to your GitHub repository"
echo "2. Push to master branch for CI build"
echo "3. Run 'Preview Builder' workflow manually for preview release"
echo "4. Create and push a tag 'v1.0.0' for full release"
echo ""
