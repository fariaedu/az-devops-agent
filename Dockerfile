FROM ubuntu:22.04

RUN apt-get update
RUN apt upgrade -y
RUN apt install -y \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libicu70 \
        libunwind8 \
        netcat \
	openjdk-17-jre-headless \
        nodejs \
        nodejs npm\
        maven


# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Another option is to run the agent as root.
ENV AGENT_ALLOW_RUNASROOT="true"
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
ENV JAVA_HOME_17_X64="/usr/lib/jvm/java-17-openjdk-amd64"

ENTRYPOINT ./start.sh