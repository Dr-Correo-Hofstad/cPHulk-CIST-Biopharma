#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script as root."
  exit 1
fi

# Define paths
SRC_DIR="./src"
PLUGIN_DIR="/usr/local/cpanel/whostmgr/docroot/cgi/whm_cphulk_geoip"
CONF_FILE="whm_cphulk.conf"
REPORTER_SCRIPT="cphulk_reporter.pl"
INDEX_CGI="index.cgi"

echo "=== Starting cPHulk GeoIP FPS Reporter Installation ==="

# 1. Create target directory if it doesn't exist
if [ ! -d "$PLUGIN_DIR" ]; then
    echo "Creating directory: $PLUGIN_DIR"
    mkdir -p "$PLUGIN_DIR"
fi

# 2. Verify source files exist and copy them
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Source directory '$SRC_DIR' not found. Run this from the repository root."
    exit 1
fi

echo "Copying source files to WHM extension directory..."
cp -r "$SRC_DIR"/* "$PLUGIN_DIR/"

# 3. Set strict, secure ownership and permissions
echo "Setting permissions..."
chown -R root:root "$PLUGIN_DIR"
chmod 755 "$PLUGIN_DIR"

# Make CGI scripts and backend hooks executable
if [ -f "$PLUGIN_DIR/$REPORTER_SCRIPT" ]; then chmod 755 "$PLUGIN_DIR/$REPORTER_SCRIPT"; fi
if [ -f "$PLUGIN_DIR/$INDEX_CGI" ]; then chmod 755 "$PLUGIN_DIR/$INDEX_CGI"; fi

# 4. Register the Application Configuration with WHM
if [ -f "$PLUGIN_DIR/$CONF_FILE" ]; then
    echo "Registering plugin with cPanel AppConfig..."
    /usr/local/cpanel/bin/register_appconfig "$PLUGIN_DIR/$CONF_FILE"
else
    echo "Warning: $CONF_FILE not found in src. Skipping cPanel application registration."
fi

echo "=== Installation Complete ==="
echo "----------------------------------------------------------------------"
echo "CRITICAL STEP REQUIRED TO ENGAGE HOOKS:"
echo "1. Log into your WHM Control Panel."
echo "2. Navigate to: Security Center -> cPHulk Brute Force Protection."
echo "3. Go to the 'Configuration Settings' tab."
echo "4. Under 'Trigger a Command When an IP is Blocked', add this path:"
echo "   $PLUGIN_DIR/$REPORTER_SCRIPT %ip% %service%"
echo "5. Click 'Save'."
echo "----------------------------------------------------------------------"
