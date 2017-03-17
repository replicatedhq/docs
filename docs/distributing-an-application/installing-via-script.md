+++
date = "2016-07-03T04:02:20Z"
title = "Installing Replicated with the Easy Install Script"
description = "Instructions for installing Replicated via the easy install script."
keywords= "installing"
+++

We provide an easy-to-use one-line installation process (via shell script) which will detect your OS, ask a few questions and install both docker-engine and the required Replicated components.

If you want to always release your application with a specific version of Replicated you can read how to [always install a specific version of Replicated](/kb/supporting-your-customers/install-known-versions/). 

### Basic Install

Save the install script to file and run.  We recommend reading and understanding the install script prior to running.

```shell
curl -sSL -o install.sh https://get.replicated.com/docker
sudo bash ./install.sh
```

Quick install with bash pipe.

```shell
curl -sSL https://get.replicated.com/docker | sudo bash
```

### Flags 

The install script can take flags to help your customers with specialized enterprise setups.

|Flag|Usage|
|----|-----|
|no-auto|Prompts will wait indefinitely instead of 20 second timeouts|
|ui-bind-port <PORT_NUMBER>|Change the default UI port binding from port 8800|
|docker-version <VERSION>|Install with a specific version of Docker|
|bypass-storagedriver-warnings|For automation bypasses the warning for devicemapper with loopback|

Example call with flags:

```shell
curl -sSL https://get.replicated.com/docker | sudo bash -s no-auto ui-bind-port=8000
```

For CI/CD automation additional flags are also supported, see the "command line flags"
section of the script.

{{< note title="Best practices with the easy-install script" >}}
When you're ready to start shipping to customers we recommend that you proxy this install script with a TLS cert matching your domain name.  The script should always be served with TLS.
{{< /note >}}

## Installing Behind A Proxy
The Replicated installation script supports environments where an HTTP proxy server is required to access the Internet. The installation script will prompt for the proxy address and will set up Replicated and Docker to use the supplied value.

An example of running the Replicated installation script with a proxy server is:
```shell
curl -x http://<proxy_address>:<proxy_port> https://get.replicated.com/docker | sudo bash
```

## Post-Installation Maintenance

## Upgrade to latest Replicated build.
If you would like to upgrade Replicated to the latest release simply [rerun the installation script](https://www.replicated.com/docs/distributing-an-application/installing/#easy-installation) and that will upgrade the Replicated components to the latest build.

## Restarting Replicated
If you installed Replicated using the easy installation script, the script will have created an init service you can use to control Replicated. In this case, restarting replicated varies depending on your host OS, please see below for the correct instructions to restarting replicated.

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

## Removing Replicated
To remove Replicated when install via the easy install script you can run the following script.

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

