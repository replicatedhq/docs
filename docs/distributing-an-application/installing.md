+++
date = "2016-07-03T04:02:20Z"
title = "Installing Replicated"
description = "Instructions for installing Replicated via the easy install script, manually or behind a proxy. Also includes instructions for uninstalling Replicated."
keywords= "installing, removing, migrating"
weight = "305"
categories = [ "Distributing" ]

[menu.main]
Name       = "Installing Replicated"
identifier = "installing"
parent     = "/distributing-an-application"
url        = "/docs/distributing-an-application/installing"
+++

{{< note title="Replicated 2.0" >}}
The content in this document is specific to Replicated 2.0. If you are looking for the
Replicated 1.2 version of this document, it is available at
<a href="distributing-an-application/installing-1.2/">{{< baseurl >}}distributing-an-application/installing-1.2/</a>
{{< /note >}}

## Host Setup
Before installing your app, you need to install Replicated on a compatible machine.

## Supported Operating Systems
Replicated supports any Linux-based server operating system that can run current versions of Docker.

Your machine must support docker-engine {{< docker_version_minimum >}} - {{< docker_version_default >}} (with {{< docker_version_default >}} being the recommended version). This
also requires a 64-bit distribution with a kernel minimum of 3.10. For detailed requirements and
installation guides see the docker installation docs.

## Current Replicated Versions
| Image	| Stable Version |
|-------|----------------|
| replicated | 2.3.2 <br /> 14 December, 2016 |
| replicated-ui | 2.3.2 <br /> 14 December, 2016 |
| replicated-operator | 2.3.2 <br /> 14 December, 2016 |

## Easy Installation
We provide an easy-to-use one-line installation process (via shell script) which will detect your OS, ask
a few questions and install the Replicated components for you including docker-engine. If you want to
install a specific version of Replicated, we have a guide for that in our KB. More details on the
installation script:

### With Timeout Prompts
```shell
curl -sSL https://get.replicated.com/docker | sudo bash
```

### Wait Indefinitely
```shell
curl -sSL https://get.replicated.com/docker | sudo bash -s no-auto
```

You can set the port for serving the Replicated web interface by using the ui-bind-port option.

### Install the Replicated UI at a Custom Port
```shell
curl -sSL https://get.replicated.com/docker | sudo bash -s ui-bind-port 8000
```

When you're ready to start shipping to customers, you can either proxy this install script or provide TLS
certs for us to CNAME it for you.

## Installing Additional Nodes
By default Replicated will add its local host as the first node when running the installation script from
above. It is possible to add additional hosts as nodes to your cluster by running the following script on
remote hosts. These nodes will appear in the cluster page of the On-prem UI.

### With Timeout Prompts
```shell
curl -sSL https://get.replicated.com/operator | sudo bash
```

### Wait Indefinitely
```shell
curl -sSL https://get.replicated.com/operator | sudo bash -s no-auto
```

## Accessing the On-prem UI
The Replicated On-Prem UI is web-based, Replicated is available at port 8800 (by default) over
HTTPS of the server you've installed Replicated on (make sure that port 8800 is accessible
from your local computer).

You'll need to [create & download a license file](/distributing-an-application/create-licenses/)
for yourself on the vendor portal & then just follow the instructions from there.

# Advanced Installation Options
## Manual Installation
If you'd rather install the components manually, you can! Just use the 4 following steps.

### 1. Install Docker
Currently the Replicated installation script installs Docker version {{< docker_version_default >}}
Refer to the Docker Installation Guide for [Debian](https://docs.docker.com/engine/installation/linux/debian/),
[Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntulinux/), [CentOS](https://docs.docker.com/engine/installation/linux/centos/),
[Fedora](https://docs.docker.com/engine/installation/linux/fedora/), or [RHEL](https://docs.docker.com/engine/installation/linux/rhel/).

### 2. Run Replicated & UI Containers
```shell
export DOCKER_HOST_IP=172.17.0.1  # Set this appropriately to docker0 address
export LOCAL_ADDRESS=10.240.0.2  # Set this to the internal address of the server (usually eth0, but not 127.0.0.1)

echo 'alias replicated="sudo docker exec -it replicated replicated"' > /etc/replicated.alias

docker run -d --name=replicated \
        -p 9874-9879:9874-9879/tcp \
        -v /etc/replicated.alias:/etc/replicated.alias \
        -v /var/lib/replicated:/var/lib/replicated \
        -v /var/run/replicated:/var/run/replicated \
        -v /etc/docker/certs.d:/host/etc/docker/certs.d \
        -v /var/run/docker.sock:/host/var/run/docker.sock \
        -v /proc:/host/proc:ro \
        -v /etc:/host/etc:ro \
        -e DOCKER_HOST_IP=$DOCKER_HOST_IP \
        -e LOCAL_ADDRESS=$LOCAL_ADDRESS \
        quay.io/replicated/replicated:latest

docker run -d --name=replicated-ui \
        -p 8800:8800/tcp \
        -v /var/run/replicated:/var/run/replicated \
        quay.io/replicated/replicated-ui:latest
```

### 3. Upload the License
1. Navigate to https://&lt;your server address&gt;:8800.
1. Follow the prompts to configure certificates, upload license, and run the preflight checks.

### 4. Run Operator Container
1. Click on the Cluster link
![Cluster](/static/manual-install-2.x/click-cluster.png)
1. Click the Add Node button
![Add Node](/static/manual-install-2.x/add-node.png)
1. Select Docker Run option
1. Copy the command from the text area below
![Run Command](/static/manual-install-2.x/copy-command.png)
1. Paste and run the command in the terminal window

At this point, the new node should show up on the Cluster page.

### 4. Start the Application
1. Click on the Dashboard link
1. Click the Start Now button
![Start Now](/static/manual-install-2.x/start-now.png)

{{< note title="There is no Start Now button" >}}
If Replicated is still pulling application images, there will be no Start Now button.
If this is the case, then just wait for the pull to finish.
{{< /note >}}

{{< note title="Pre-flight checks again" >}}
Since a new node running Replicated Operator has joined the cluster, Replicated will
want to run preflight checks on it before starting the application.
If that's the case, the Start Now button will be replaced with the Run Checks button.

![Start Now](/static/manual-install-2.x/preflight-again.png)
{{< /note >}}

## Installing Behind A Proxy
The Replicated installation script supports environments where an HTTP proxy server is required to access the Internet. The installation script will prompt for the proxy address and will set up Replicated and Docker to use the supplied value.

An example of running the Replicated installation script with a proxy server is:
```shell
curl -x http://<proxy_address>:<proxy_port> https://get.replicated.com/docker | sudo bash
```

# Post-Installation Maintenance
## Restarting Replicated
If you installed Replicated using the easy installation script, the script will have created an init service you can
use to control Replicated. In this case, restarting replicated varies depending on your host OS, please see below for
the correct instructions to restarting replicated.

## Upgrade to latest Replicated build.
If you would like to upgrade Replicated to the latest release simply [rerun the installation script](https://www.replicated.com/docs/distributing-an-application/installing/#easy-installation) and that will upgrade the Replicated components to the latest build.

### Ubuntu/Debian
```shell
service replicated restart
service replicated-ui restart
service replicated-operator restart
```

### CentOS/RHEL/Fedora
```shell
sudo systemctl restart replicated replicated-ui replicated-operator
```

*If you need to reset your console password please refer to the [reseting your password](/kb/supporting-your-customers/resetting-console-password/) (Reseting the On-Prem Admin Password)
in the On-Prem CLI section.*

## List Installed Replicated Version
You can also use the [CLI](/reference/replicated-cli/) to determine the version
of the container.


## Removing Replicated
To remove Replicated from a given host you can run the following script.

### Ubuntu/Debian
```shell
service replicated stop
service replicated-ui stop
service replicated-operator stop
docker rm -f replicated replicated-ui replicated-operator
docker images | grep "quay\.io/replicated" | awk '{print $3}' | xargs sudo docker rmi -f
apt-get remove -y replicated replicated-ui replicated-operator
apt-get purge -y replicated replicated-ui replicated-operator
rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/init.d/replicated* /etc/default/replicated* /var/log/upstart/replicated* /etc/systemd/system/replicated*
```

### CentOS/RHEL/Fedora
```shell
systemctl stop replicated replicated-ui replicated-operator
service replicated stop
service replicated-ui stop
service replicated-operator stop
docker rm -f replicated replicated-ui replicated-operator
docker images | grep "quay\.io/replicated" | awk '{print $3}' | xargs sudo docker rmi -f
yum remove -y replicated replicated-ui replicated-operator
rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/default/replicated* /etc/systemd/system/replicated* /etc/sysconfig/replicated* /etc/systemd/system/multi-user.target.wants/replicated* /run/replicated*
```

## Migrating from Replicated v1
Replicated provides a one line migration script to upgrade your v1 installation to v2. The script will first stop
your app and backup all Replicated data in case there is a need for a restore. To invoke the migration script all
you have to do is run the script below and follow the prompts.

```shell
curl -sSL https://get.replicated.com/migrate-v2 | sudo bash
```

{{< warning title="Warning" >}}
To prevent loss of data, backing up your server is highly recommended before performing a migration.
{{< /warning >}}
