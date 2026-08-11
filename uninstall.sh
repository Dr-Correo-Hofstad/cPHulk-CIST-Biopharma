#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script as root."
  exit 1
fi

# Define paths matching the installer
PLUGIN_DIR="/usr/local/cpanel/whostmgr/docroot/cgi/whm_cphulk_geoip"
CONF_FILE="whm_cphulk.conf"

echo "=== Starting cPHulk GeoIP FPS Reporter Uninstallation ==="

# 1. Unregister the AppConfig from WHM
if [ -f "$PLUGIN_DIR/$CONF_FILE" ]; then
    echo "Unregistering plugin from cPanel AppConfig..."
    /usr/local/cpanel/bin/unregister_appconfig "$PLUGIN_DIR/$CONF_FILE"
else
    echo "AppConfig configuration file not found at path. Attempting forced unregistration..."
    /usr/local/cpanel/bin/unregister_appconfig whm_cphulk_geoip 2>/dev/null
fi

# 2. Clean up the plugin files and directory
if [ -d "$PLUGIN_DIR" ]; then
    echo "Removing plugin directory and assets: $PLUGIN_DIR"
    rm -rf "$PLUGIN_DIR"
else
    echo "Plugin installation directory not found. Skipping file removal."
fi

echo "=== Uninstallation Complete ==="
echo "NOTICE: Remember to manually remove the script command path from your"
echo "WHM cPHulk Configuration Settings panel if you configured it previously."
