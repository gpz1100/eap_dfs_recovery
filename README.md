# TP-Link EAP DFS Event Recovery script

# Introduction
After DFS event, EAP fails to restore original channel unless unit is rebooted or 5GHz wifi settings reapplied.

# Solution
This script performs the equivalent of savings the 5GHz wifi settings from the wireless settings page using *curl*. Before applying any changes script determines if wifi settings have deviated from configured settings. If not it exits, otherwise settings are applied. Cron can be used to periodically execute to the script; ie every 30 minutes or an hour - **`*/30 * * * *`**  for every 30 minutes.  

Should another DFS event occur after channel recovery, it is expected EAP will once again change channels until the next time script is run.

# IMPORTANT 
Script is intended to access EAP which is **not managed** by controller. For controller managed devices, use built in API to perform similar task.

# Configuring the script
All variables must be modified to suit your own configuration. As provided, script will configure 5GHz as follows:
* Wireless Mode: 802.11a/n/ac/ax mixed
* Channel Width: 160 MHz
* Channel: 100/5500MHz
* Tx Power: 28

## Variables
To obtain the username (usually admin) and password hash use the **inspect** function of the browser

>### Credentials
1) Open EAP admin page using IP or hostname
2) Open browser **inspect** function
3) Click on network tab
4) Ensure **Preserve log** is checked
5) Enable **recording**
6) **Login**
7) In inspect window, click on **Fetch/XHR**
8) Look for a line containing just the IP or hostname
9) Click on the **Payload** tab to reveal hashed password
10) Copy and paste to the USERNAME and PASSWORD variables without the {} brackets

* USERNAME="{username, usually admin}"
* PASSWORD="{32 character password}"

>### Wifi Settings
1) Continuing from step 9 in credentials
2) On the top row, Click the **WIRELESS** tab, then select **5G**
3) Scroll to the bottom then click **Save**
4) Stop recording by clicking the **record button** again
5) In search box enter **wireless.basic.json** then **Payload** tab on the right
6) There will be several of these files. The one of interest will have **radioID: 1** and should be at the top.
7) Adjust the variable values in the script as needed. They correspond directly except the channel.  
    **Channel number** in the payload tab corresponds to DESIRED_CHANNEL_**ID** variable in the script.  
Adjust DESIRED_CHANNEL (without the **_ID) to the numeric channel number  
For example an ID of 9 corresponds to channel 100.
 
    DESIRED_CHANNEL="100"  
    DESIRED_CHANNEL_ID="9"
   
    List of channel numbers and corresponding channel id's is provided at the top of the script.









