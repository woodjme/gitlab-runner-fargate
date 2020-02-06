FROM ubuntu:bionic

# Update
RUN apt-get update -y && apt-get upgrade -y

# Install deps
RUN apt-get install -y curl git

# Install Gitlab Runner
RUN curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
RUN dpkg -i gitlab-runner_amd64.deb

COPY ./entrypoint.sh ./entrypoint.sh

ENV REGISTER_NON_INTERACTIVE=true
ENTRYPOINT [ "./entrypoint.sh" ]
