#!/bin/python
import uuid
import time
import boto
import json
import os
from boto.sqs.message import RawMessage

def addMessageToQueue(env, project, sha):
    # Data required by the API
    data = {
        "project": project,
        "sha": "{0}-{1}".format(env, sha)
    }

    # Connect to SQS and open the queue
    sqs = boto.connect_sqs(os.environ["AWS_ACCESS_KEY"], os.environ["AWS_SECRET_KEY"])
    q = sqs.create_queue("chatops-deployer-{0}".format(env))

    # Put the message in the queue
    m = RawMessage()
    m.set_body(json.dumps(data))
    q.write(m)

addMessageToQueue("staging", os.environ["CIRCLE_PROJECT_REPONAME"], os.environ["CIRCLE_SHA1"][:7])
addMessageToQueue("production", os.environ["CIRCLE_PROJECT_REPONAME"], os.environ["CIRCLE_SHA1"][:7])
