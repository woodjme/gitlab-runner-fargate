# Gitlab Runner Fargate

## Usage

### Setup Fargate

#### Create a Fargate Cluster

```bash
aws ecs create-cluster --cluster-name gitlab-runner-cluster
```

#### Register a Task Definition

* Replace http://gitlab.com if you're using a self-hosted GitLab Instance
* Replace $REGISTRATION_TOKEN with your own token
* Update the CPU and memory values if you wish, make sure it's a [supported configuration](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html)

```bash
aws ecs register-task-definition --family gitlab-runner \
--container-definitions "[{\"name\": \"gitlab-runner-instance\",\"image\": \"woodjme/gitlab-runner-fargate\",\"environment\": [{\"name\": \"CI_SERVER_URL\", \"value\": \"https://gitlab.com\"},{\"name\": \"REGISTRATION_TOKEN\", \"value\": \"$REGISTRATION_TOKEN\"},{\"name\": \"RUNNER_NAME\", \"value\": \"fargate\"}]}]" \
--network-mode "awsvpc" \
--requires-compatibilities FARGATE \
--cpu "1024" \
--memory "2048"
```

#### Create a Service

You need to replace `subnet-xyz` with a subnet in your account. You can get this quick with `aws ec2 describe-subnets --query 'Subnets[0].SubnetId'`

```bash
aws ecs create-service --cluster gitlab-runner-cluster \
--service-name gitlab-runner-service \
--task-definition gitlab-runner \
--desired-count 1 \
--launch-type "FARGATE" \
--network-configuration "awsvpcConfiguration={subnets=[subnet-xyz]}"
```

Once the service starts you should see a registered runner in GitLab
