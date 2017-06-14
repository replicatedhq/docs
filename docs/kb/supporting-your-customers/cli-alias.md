+++
date = "2017-06-13T00:00:00Z"
lastmod = "2017-06-14T00:00:00Z"
title = "Replicated CLI Alias"
weight = "999999"
categories = [ "Knowledgebase", "Supporting Your Customers" ]
+++

The Replicated [Easy Install Scripts](https://www.replicated.com/docs/distributing-an-application/installing-via-script/) will automatically set up the [Replicated CLI V1](https://www.replicated.com/docs/reference/replicated-cli/) and [Replicated CLI V2](https://www.replicated.com/docs/reference/replicatedctl/) aliases. However, if your customer has upgraded from Replicated version 2.8.2 to 2.9.0, then the Replicated CLI V2 alias is not automatically available. Likewise, if your customer performed a [manual installation](https://www.replicated.com/docs/distributing-an-application/installing-manually/), then neither Replicated CLI versions will be available as an alias.

Depending on your scheduler, run the following shell scripts as `sudo` to set up the Replicated CLI V1 and V2 alias on Replicated installations.

_Please note that the customer will have to hit enter after the last command._

### Replicated Scheduler

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

### Swarm Scheduler

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

### Kubernetes Scheduler

```shell
cat > /usr/local/bin/replicated <<-EOF
#!/bin/sh

# test if stdout is a terminal
if [ -t 1 ]; then
kubectl exec -it "\$(kubectl get pods -l=app=replicated -l=tier=master -o=jsonpath='{.items..metadata.name}')" -c replicated -- replicated "\$@"
else
kubectl exec "\$(kubectl get pods -l=app=replicated -l=tier=master -o=jsonpath='{.items..metadata.name}')" -c replicated -- replicated "\$@"
fi
EOF
chmod a+x /usr/local/bin/replicated
cat > /usr/local/bin/replicatedctl <<-EOF
#!/bin/sh

# test if stdout is a terminal
if [ -t 1 ]; then
kubectl exec -it "\$(kubectl get pods -l=app=replicated -l=tier=master -o=jsonpath='{.items..metadata.name}')" -c replicated -- replicatedctl "\$@"
else
kubectl exec "\$(kubectl get pods -l=app=replicated -l=tier=master -o=jsonpath='{.items..metadata.name}')" -c replicated -- replicatedctl "\$@"
fi
EOF
chmod a+x /usr/local/bin/replicatedctl
```

