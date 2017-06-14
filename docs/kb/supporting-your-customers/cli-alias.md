+++
date = "2017-06-13T00:00:00Z"
lastmod = "2017-06-13T00:00:00Z"
title = "Replicated CLI alias"
weight = "999999"
categories = [ "Knowledgebase", "Supporting Your Customers" ]
+++

The Replicated [Easy Install Scripts](https://www.replicated.com/docs/distributing-an-application/installing-via-script/) will automatically set up the [Replicated CLI V1](https://www.replicated.com/docs/reference/replicated-cli/) and [Replicated CLI V2](https://www.replicated.com/docs/reference/replicatedctl/) aliases. However, if your customer has upgraded from Replicated version 2.8.2 to 2.9.0, then the Replicated CLI V2 alias is not automatically available. Likewise, if your customer performed a [manual installation](https://www.replicated.com/docs/distributing-an-application/installing-manually/), then neither Replicated CLI versions will be available as an alias.

### Native Scheduler
Run the following shell script as `sudo` to set up the Replicated CLI V1 and V2 alias on Replicated installations on the native scheduler.

```shell
cat > /usr/local/bin/replicated <<-EOF
#!/bin/sh

# test if stdout is a terminal
if [ -t 1 ]; then
sudo docker exec -it replicated replicated "\$@"
else
sudo docker exec replicated replicated "\$@"
fi
EOF
chmod a+x /usr/local/bin/replicated
cat > /usr/local/bin/replicatedctl <<-EOF
#!/bin/sh

# test if stdout is a terminal
if [ -t 1 ]; then
sudo docker exec -it replicated replicatedctl "\$@"
else
sudo docker exec replicated replicatedctl "\$@"
fi
EOF
chmod a+x /usr/local/bin/replicatedctl
```

_Please note that the customer will have to hit enter after the last command._

### Swarm Scheduler
Run the following shell script as `sudo` to set up the Replicated CLI V1 and V2 alias on Replicated installations on the Swarm scheduler.

```shell
cat > /usr/local/bin/replicated <<-EOF
#!/bin/sh

# test if stdout is a terminal
if [ -t 1 ]; then
sudo docker exec -it "\$(sudo docker inspect --format "{{.Status.ContainerStatus.ContainerID}}" "\$(sudo docker service ps "\$(sudo docker service inspect --format "{{.ID}}" replicated_replicated)" -q | awk "NR==1")")" replicated "\$@"
else
sudo docker exec "\$(sudo docker inspect --format "{{.Status.ContainerStatus.ContainerID}}" "\$(sudo docker service ps "\$(sudo docker service inspect --format "{{.ID}}" replicated_replicated)" -q | awk "NR==1")")" replicated "\$@"
fi
EOF
chmod a+x /usr/local/bin/replicated
cat > /usr/local/bin/replicatedctl <<-EOF
#!/bin/sh

# test if stdout is a terminal
if [ -t 1 ]; then
sudo docker exec -it "\$(sudo docker inspect --format "{{.Status.ContainerStatus.ContainerID}}" "\$(sudo docker service ps "\$(sudo docker service inspect --format "{{.ID}}" replicated_replicated)" -q | awk "NR==1")")" replicatedctl "\$@"
else
sudo docker exec "\$(sudo docker inspect --format "{{.Status.ContainerStatus.ContainerID}}" "\$(sudo docker service ps "\$(sudo docker service inspect --format "{{.ID}}" replicated_replicated)" -q | awk "NR==1")")" replicatedctl "\$@"
fi
EOF
chmod a+x /usr/local/bin/replicatedctl
```

_Please note that the customer will have to hit enter after the last command._

### Kubernetes Scheduler
Replicated on the Kubernetes scheduler does not currently support Replicated CLI aliasing.

