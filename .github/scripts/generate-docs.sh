#!/bin/bash

# --- 1. REQUIRE VERSION ---
if [ -z "$PASSED_VERSION" ]; then
    echo "::error::PASSED_VERSION missing"
    exit 1
fi

VERSION=$PASSED_VERSION

# --- 2. PARSE CHANGELOG.MD ---
# 1. Start at the header matching your version
# 2. Stop ONLY when hitting a line that starts with '## ' followed by a number
# 3. This allows it to skip over '## Improvements'
RELEASE_NOTES=$(awk "/^## ${VERSION}/{flag=1;next} /^## [0-9]/{flag=0} flag" CHANGELOG.md)

# Clean up: Remove empty lines and format bullets
# This looks for lines starting with '-' and converts them to '* '
IMPROVEMENTS=$(echo "$RELEASE_NOTES" | grep "^-" | sed 's/^- /* /')

# Check if we actually found improvements
if [ -z "$IMPROVEMENTS" ]; then
    echo "::warning::No improvements found for version $VERSION. Check if CHANGELOG.md format matches."
    IMPROVEMENTS="* Updated version."
fi

# --- 3. CREATE THE MDX ---
RELEASE_DATE=$(date +%Y-%m-%d)
FINAL_DOWNLOAD_URL="https://www.npmjs.com/package/@newrelic/newrelic-capacitor-plugin/v/${VERSION}"

cat > "release-notes.mdx" << EOF
---
subject: ${AGENT_TITLE}
releaseDate: '${RELEASE_DATE}'
version: ${VERSION}
downloadLink: '${FINAL_DOWNLOAD_URL}'
---

## Improvements

${IMPROVEMENTS}
EOF

# --- 4. EXPORT CONTRACT ---
echo "FINAL_VERSION=$VERSION" > release_info.env

echo "✅ Generated release-notes.mdx for version $VERSION"