### cPHulk GeoIP FPS Reporter

An event-driven WHM (Web Host Manager) plugin and native cPHulk integration hook designed to intercept authentication-layer attacks on cPanel/WHM systems. 

Unlike layer-7 application scanners (e.g., ModSecurity), this tool operates explicitly at the authentication perimeter, capturing real-time Indicators of Compromise (IoCs) across protocols including SSH, FTP, IMAP/POP3, cPanel, and WHM gateways. 

### Functional Architecture

When malicious actors exceed the server's threshold for failed login attempts, cPHulk generates an internal isolation trigger. This module intercepts that specific event, processes the threat vector, and routes automated intelligence reports to our security operations: 

text

```
[ Brute Force Event ] ──> [ cPHulk Hook Trigger ] ──> [ Local GeoIP Translation ]
                                                                   │
[ Target Intelligence Email ] <── [ Fast People Search Format ] <── [ Google Maps Reverse API ]

```

Use code with caution.

### Repository Structure

Based on our production deployment environment, the assets are organized as follows: 

text

```
├── docs/
│   ├── install.md             # Walkthrough for activating WHM application links
│   └── uninstall.md           # Cleanup routines and unregistration instructions
├── images/                    # Visual assets, interface mockups, and layout configurations
├── src/                       # Source directory containing compiled plugin modules
│   ├── cphulk_reporter.pl     # Core event hook parser and background execution routine
│   ├── index.cgi              # WHM User Interface dashboard entry point
│   └── whm_cphulk.conf        # cPanel AppConfig registration configuration file
├── DATA_PRIVACY_AND_BORDER.md # Security policy guidelines regarding outbound processing
├── EXPORT_CONTROL.md          # Distribution boundaries and regulatory classifications
├── LICENSE                    # Software permissions manifest
├── install.sh                 # Master deployment utility script
├── uninstall.sh               # Master removal utility script
└── README.md                  # This repository mapping file

```

Use code with caution.

### Setup & Integration

### 1\. Script Configuration

Before registering the program components, open `src/cphulk_reporter.pl` in an elevated text editor and replace the default credentials placeholder with a valid Google Maps Geocoding API key: 

perl

```
my $GOOGLE_API_K = 'YOUR_GOOGLE_MAPS_API_KEY';

```

Use code with caution.

### 2\. Run the Installer

Execute the automated bash utility script with root privileges to automatically handle directories, transfer assets, establish restrictive ownership permissions (`root:root`), and register with the cPanel AppConfig database: 

bash

```
chmod +x install.sh
sudo ./install.sh

```

Use code with caution.

### 3\. Bind the Live Hook Trigger

To switch this plugin into an active, event-driven state, the script must be explicitly tied to cPHulk inside your administration interface: 

1.  Log into your **WHM Control Panel**. 

2.  Navigate to **Security Center** -> **cPHulk Brute Force Protection**. 

3.  Select the **Configuration Settings** tab. 

4.  Scroll down to the **Command Notifications** options (*Trigger a Command When an IP is Blocked*). 

5.  Paste the absolute tracking file path into the input field: 

    text

    ```
    /usr/local/cpanel/whostmgr/docroot/cgi/whm_cphulk_geoip/cphulk_reporter.pl %ip% %service%

    ```

    Use code with caution.

6.  Commit and save changes to initialize threat logging. 

### Maintenance and Removal

To cleanly remove the application components, clear out configuration bindings, and purge the cPanel registration table, execute the companion uninstaller script directly from your terminal: 

bash

```
chmod +x uninstall.sh
sudo ./uninstall.sh

```

Use code with caution.

*Note: Ensure you also clear out the script string from your WHM cPHulk Configuration panel back-end to complete the cleanup process.*
