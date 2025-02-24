# #!/bin/bash
# set -ex 
# exec > /var/log/user-data.log 2>&1
# INSTANCE_ID=$(ec2metadata --instance-id)
# RUNNER_NAME="runner-${INSTANCE_ID}"
# ACTION_RUNNER_VERSION=2.311.0
# GITHUB_ORG="aqeelsadiq"
# # PAT="ghp"


# apt-get update -y && apt-get upgrade -y
# apt-get install -y curl unzip jq
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install

# cd /home/ubuntu

# mkdir -p actions-runner && cd actions-runner


# curl -o actions-runner-linux-x64-${ACTION_RUNNER_VERSION}.tar.gz -L \
#   https://github.com/actions/runner/releases/download/v${ACTION_RUNNER_VERSION}/actions-runner-linux-x64-${ACTION_RUNNER_VERSION}.tar.gz


# tar xzf actions-runner-linux-x64-${ACTION_RUNNER_VERSION}.tar.gz
# chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
# chmod +x /home/ubuntu/actions-runner/*.sh

# TOKEN=$(curl -s -L -X POST \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer $PAT" \
#   -H "X-GitHub-Api-Version: 2022-11-28" \
#   https://api.github.com/repos/$GITHUB_ORG/test/actions/runners/registration-token | jq -r '.token')

# sudo -u ubuntu /home/ubuntu/actions-runner/config.sh --url https://github.com/$GITHUB_ORG/test --token $TOKEN --name $RUNNER_NAME --unattended --replace

# cd /home/ubuntu/actions-runner
# sudo ./svc.sh install
# sudo ./svc.sh start






# cat <<EOF > /home/ubuntu/self_stop.sh
# #!/bin/bash

# INSTANCE_ID=$(ec2metadata --instance-id)
# echo "Instance ID: $INSTANCE_ID"
# RUNNER_DIR="/home/ubuntu/actions-runner"

# RUNNING_JOBS=$(cd $RUNNER_DIR && ./config.sh --status | grep "Running job" | wc -l)
# if [[ "$RUNNING_JOBS" -eq 0 ]]; then
#     echo "No running jobs detected. Stopping EC2 instance: $INSTANCE_ID"
#     aws ec2 stop-instances --instance-ids $INSTANCE_ID
# else
#     echo "Runner is busy. Jobs running: $RUNNING_JOBS"
# fi
# EOF

# sudo chown ubuntu:ubuntu /home/ubuntu/self_stop.sh
# chmod +x /home/ubuntu/self_stop.sh

# # (crontab -l 2>/dev/null; echo "*/5 * * * * /bin/bash /home/ubuntu/self_stop.sh >> /home/ubuntu/cron.log 2>&1") | crontab -
# echo "*/15 * * * * /bin/bash /home/ubuntu/self_stop.sh >> /home/ubuntu/cron.log 2>&1" | sudo -u ubuntu crontab -




