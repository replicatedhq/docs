+++
date = "2016-07-01T00:00:00Z"
lastmod = "2016-07-01T00:00:00Z"
title = "Restoring From a Snapshot"
weight = "999999"
categories = [ "Knowledgebase", "Supporting Your Customers" ]
+++

**The snapshots functionality in Replicated is for disaster recovery purposes.**

If you have enabled snapshots for your app they will by default run every 24 hours, 
optionally your users can run a snapshot from the on-prem console at any time. The default 
location for saving a snapshot on a replicated enabled host is: `/var/lib/replicated/snapshots`, 
the last 3 snapshots will be located in that directory.
*Note: We highly recommend you copy this folder to a additional location on a different physical 
host/SAN to ensure redundancy.*

To restore you need to create a fresh install of replicated which you can find instructions 
for [here](/distributing-an-application/installing/#easy-installation). Before 
running the web console at https://<server_address>:8800 place a copy of the full snapshot directory 
on the host. Proceed through the https setup screen and on the upload your license page click the 
"restore from a snapshot" link.

![Restore](/static/restore-start.png)

1. Enter the path on the host where you have copied the snapshots folder,
1. Click “Browse snapshots”:
1. Locate the latest version you would like to backup from and click the “Restore” button.

![Restore](/static/restore-location.png)

You will be given options for restoring, downloading the volumes, or deleting from the prior 
install, in this case we will restore to the local host by clicking the “restore” button.

![Restore Hosts](/static/restore-hosts.png)

Next you will be prompted to specify which host you would like to restore to (for this example 
I am going to restore to local).

![Restore Local Host](/static/restore-local-host.png)

The last step is to set the correct interface for the localhost, in this case it is “eth0” and one last time hit the “restore” button.

![Restore Local Host Interface](/static/restore-local-host-interface.png)

You have now restored your snapshot! Take yourself to the console.

For example of advanced snapshot setups make sure to check out our 
[Zero Downtime Backups With Replicated](https://support.replicated.com/hc/en-us/articles/216706397-Zero-Downtime-Backups-with-Replicated-Redis-) article.

