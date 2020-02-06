#!/bin/bash

# Register
gitlab-runner register \
--non-interactive \
--executor shell \
--locked=false

# Get Runner Token
RUNNER_TOKEN=`cat /etc/gitlab-runner/config.toml | grep token | awk -F '"' '{print $2}'`

# Wait for a job and execute
gitlab-runner run-single \
-t ${RUNNER_TOKEN} \
--executor shell \
--max-builds 1

# Unregister
gitlab-runner unregister -t ${RUNNER_TOKEN}
