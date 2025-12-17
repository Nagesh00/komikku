#!/bin/bash
# Quick setup verification script

echo "🔍 Komikku Fork Setup Verification"
echo "=================================="
echo ""

# Check for required files
echo "Checking required files..."
echo ""

files_ok=true

if [ -f "app/google-services.json" ]; then
    echo "✓ google-services.json exists"
else
    echo "✗ google-services.json missing"
    files_ok=false
fi

if [ -f "app/src/main/assets/client_secrets.json" ]; then
    echo "✓ client_secrets.json exists"
else
    echo "✗ client_secrets.json missing"
    files_ok=false
fi

if [ -f ".github/workflows/build_push.yml" ]; then
    echo "✓ CI workflow exists"
else
    echo "✗ CI workflow missing"
    files_ok=false
fi

if [ -f ".github/workflows/build_release.yml" ]; then
    echo "✓ Release workflow exists"
else
    echo "✗ Release workflow missing"
    files_ok=false
fi

if [ -f ".github/workflows/build_preview.yml" ]; then
    echo "✓ Preview workflow exists"
else
    echo "✗ Preview workflow missing"
    files_ok=false
fi

echo ""
echo "=================================="
echo ""

if [ "$files_ok" = true ]; then
    echo "✓ All required files are present!"
    echo ""
    echo "Next steps:"
    echo "1. Generate keystore: ./scripts/generate-keystore.sh"
    echo "2. Add GitHub secrets (see FORK_SETUP.md)"
    echo "3. Push to your fork"
    echo ""
    echo "Quick commands:"
    echo "  # For CI build:"
    echo "  git push origin master"
    echo ""
    echo "  # For preview release:"
    echo "  Run 'Preview Builder' in Actions tab"
    echo ""
    echo "  # For full release:"
    echo "  git tag v1.0.0 && git push origin v1.0.0"
else
    echo "✗ Some files are missing. Please check the setup."
fi

echo ""
echo "📚 See FORK_SETUP.md for detailed instructions"
echo ""
