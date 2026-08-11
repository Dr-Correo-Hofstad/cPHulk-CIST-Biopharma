### cPHulk GeoIP FPS Reporter Installation Guide

This guide walks you through deploying the authentic authentication-layer interception utility on your cPanel infrastructure. 

### Requirements

* Dedicated root shell access on the terminal.
* cPHulk active inside the WHM Security configurations hub.
* Valid Google Geocoding Cloud API token credentials.

### Deployment Setup

1. Place the repository onto your host server directory via secure shell transfer.
2. Edit your target API credentials directly inside your script configurations at src/cphulk_reporter.pl.
3. Give execution allowance to the orchestration tool: 

bash

chmod +x install.sh

Use code with caution.
4. Run the installation package engine: 

bash

sudo ./install.sh

Use code with caution.

### Hook Configuration (Mandatory Setup)

Unlike the cron module variant, this configuration relies on live events. To link the pipeline: 

1. Load **WHM Admin Interface** and navigate to **Security Center** -> **cPHulk Brute Force Protection**.
2. Switch to the **Configuration Settings** tab view.
3. Locate the **Command Notifications** section labeled *Trigger a Command When an IP is Blocked*.
4. Paste the following integration reference path string into the parameter input window: 

text

/usr/local/cpanel/whostmgr/docroot/cgi/whm_cphulk_geoip/cphulk_reporter.pl %ip% %service%

Use code with caution.
5. Commit and save parameters to initialize the event tracking handler.
