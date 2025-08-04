#!/usr/bin/env bash

set -euo pipefail

# patch index.html and custom.css with environment variables
# if bak files don't exist, create them - this ensures that
# any environment variable changes will be reflected in the patched files

if [ ! -f /app/public/index.html.bak ]; then
    cp /app/public/index.html /app/public/index.html.bak
    cp /app/views/index.html /app/views/index.html.bak
else
    cp /app/public/index.html.bak /app/public/index.html
    cp /app/views/index.html.bak /app/views/index.html
fi

if [ -z "${CUSTOM_TITLE:-}" ]; then
    CUSTOM_TITLE="PLANKA by GDS"
fi
echo "pre-run.sh: Setting custom title to: $CUSTOM_TITLE"
sed -i "s%<title>PLANKA</title>%<title>$CUSTOM_TITLE</title>%" /app/public/index.html
sed -i "s%<title>PLANKA</title>%<title>$CUSTOM_TITLE</title>%" /app/views/index.html

VERSION_TIMESTAMP=$(date +%s)
echo "pre-run.sh: Setting version timestamp to: $VERSION_TIMESTAMP"
sed -i "s| </head>|<link rel=\"stylesheet\" crossorigin href=\"/assets/custom.css?v=$VERSION_TIMESTAMP\"></head>|" /app/public/index.html
sed -i "s| </head>|<link rel=\"stylesheet\" crossorigin href=\"/assets/custom.css?v=$VERSION_TIMESTAMP\"></head>|" /app/views/index.html
sed -i "s| </body>|<script src=\"/assets/custom.js?v=$VERSION_TIMESTAMP\"></script></body>|" /app/public/index.html
sed -i "s| </body>|<script src=\"/assets/custom.js?v=$VERSION_TIMESTAMP\"></script></body>|" /app/views/index.html


if [ ! -f /app/public/assets/custom.css.bak ]; then
    cp /app/public/assets/custom.css /app/public/assets/custom.css.bak
else
    cp /app/public/assets/custom.css.bak /app/public/assets/custom.css
fi

if [ -z "${CUSTOM_LOGIN_TAG:-}" ]; then
    CUSTOM_LOGIN_TAG=""
fi
echo "pre-run.sh: Setting custom login tag to: $CUSTOM_LOGIN_TAG"
sed -i "s%CUSTOM_LOGIN_TAG%$CUSTOM_LOGIN_TAG%" /app/public/assets/custom.css

if [ -z "${CUSTOM_LOGIN_TITLE:-}" ]; then
    CUSTOM_LOGIN_TITLE="PLANKA"
fi
echo "pre-run.sh: Setting custom login title to: $CUSTOM_LOGIN_TITLE"
sed -i "s%CUSTOM_LOGIN_TITLE%$CUSTOM_LOGIN_TITLE%" /app/public/assets/custom.css

if [ -z "${CUSTOM_APP_TITLE:-}" ]; then
    CUSTOM_APP_TITLE="PLANKA"
fi
echo "pre-run.sh: Setting custom app title to: $CUSTOM_APP_TITLE"
sed -i "s%CUSTOM_APP_TITLE%$CUSTOM_APP_TITLE%" /app/public/assets/custom.css

echo "pre-run.sh: completed successfully."
