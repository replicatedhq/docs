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
| replicated | 2.0.1662 <br /> 19 August, 2016 |
| replicated-ui | 2.0.39 <br /> 19 August, 2016 |
| replicated-operator | 2.0.37 <br /> 19 August, 2016 |

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

When you're ready to start shipping to customers, you can either proxy this install script or provide TLS
certs for us to CNAME it for you. An example of customer facing installation guide can be found at our
unpublished demo app: [GetElk](http://preview.getelk.com/)

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
The Replicated On-Prem UI is web-based, and can be accessed via port 8800 over HTTPS of the server you've
installed Replicated on (make sure that port 8800 is accessible from your local computer).

You'll need to [create & download a license file](/distributing-an-application/create-licenses/)
for yourself on the vendor portal & then just follow the instructions from there.

# Advanced Installation Options
## Manual Installation
If you'd rather install the components manually, you can! Just use the 4 following steps.

### 1. Install Docker
Currently the Replicated installation script installs Docker version {{< docker_version_default >}}
Refer to the Docker Installation Guide for [Debian](https://docs.docker.com/installation/debian/),
[Ubuntu](https://docs.docker.com/installation/ubuntulinux/), [CentOS](https://docs.docker.com/installation/centos/),
[Fedora](https://docs.docker.com/installation/fedora/), or [RHEL](https://docs.docker.com/installation/rhel/).

### 2. Run Replicated & UI Containers
```shell
export DOCKER_HOST_IP=172.17.0.1  # Set this appropriately to docker0 address
export LOCAL_ADDRESS=10.240.0.2  # Set this to the internal address of the server (eth0 maybe?)

docker run -d --name=replicated \
        -p 9874-9880:9874-9880/tcp \
        -v /:/replicated/host:ro \
        -v /etc/replicated.alias:/etc/replicated.alias \
        -v /etc/docker/certs.d:/etc/docker/certs.d \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /var/lib/replicated:/var/lib/replicated \
        -v /etc/replicated.conf:/etc/replicated.conf \
        -e DOCKER_HOST_IP=$DOCKER_HOST_IP \
        -e LOCAL_ADDRESS=$LOCAL_ADDRESS \
        quay.io/replicated/replicated:latest

docker run -d --name=replicated-ui \
        -p 8800:8800/tcp \
        --volumes-from replicated \
        quay.io/replicated/replicated-ui:latest
```

### 3. Access Replicated UI
After the installation the On-Prem console is available at the address https://&lt;your server address&gt;:8800. There
you will be prompted for some initial setup as well as to upload a license.

### 4. Run Operator Container
Navigate to the :8800/cluster page of the On-Prem console to add a node to the cluster. Clicking the Add Node button
will present a custom Docker run command containing a secret token (or optionally an easy-install script) that can be run on the same server or an additional server to install an Operator.

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

*If you need to reset your console password please refer to the
[reseting your password](/kb/supporting-your-customers/resetting-console-password/)Reseting the On-Prem Admin Password</a>)
in the On-Prem CLI section.*

## List Installed Replicated Version
You can also use the [CLI](/reference/replicated-cli/) to determine the version
of the container


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
