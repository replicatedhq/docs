+++
date = "2016-08-12T00:00:00Z"
lastmod = "2016-08-12T00:00:00Z"
title = "Custom Support Bundle Commands Example"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

On-Prem Support Bundle allows you to leverage inline shell scripts in order to add valuable information into a support bundle. 
*Note: Every individual command will have 30 seconds to execute and then subsequently timeout.*

{{< warning title="Warning" >}}
Remember that Replicated supports many different operating systems that will be running a variety of kernels, package managers and more. Any script you choose to run on the host OS should be portable and run across any supported system.
{{< /warning >}}

```yaml
---
- name: Redis
  containers:
  - source: public
    image_name: redis
    version: latest
    config_files:
      - filename: /redis_dbsize.sh
        file_mode: 0777
        contents: |
             #!/bin/bash
        
             human_size() {
                awk -v sum="$1" ' BEGIN {hum[1024^3]="Gb"; hum[1024^2]="Mb"; hum[1024]="Kb"; for (x=1024^3; x>=1024; x/=1024) { if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x]; break; } } if (sum<1024) print "1kb"; } '
             }

             redis_cmd='/bin/redis-cli'

             for i in `seq 0 16`;
                do dbsize=`$redis_cmd -n $i dbsize | awk {'print $1'}`;
                hsize=`human_size "$dbsize"`;
                printf "database $i: %-10s%s $hsize\n";
             done
    support_commands:
    - filename: redis.log
      command: ["/redis_dbsize.sh"]
```
