# =========================
# Base dependency layer
# =========================
FROM ubuntu:26.04 AS dependencies

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
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
        npm \
        maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# =========================
# Final runtime image
# =========================
FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Copy installed dependencies from previous layer
COPY --from=dependencies /usr /usr
COPY --from=dependencies /lib /lib
COPY --from=dependencies /lib64 /lib64
COPY --from=dependencies /etc /etc

# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./

RUN chmod +x ./start.sh

# Another option is to run the agent as root.
ENV AGENT_ALLOW_RUNASROOT="true"

ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
ENV JAVA_HOME_17_X64="/usr/lib/jvm/java-17-openjdk-amd64"

ENTRYPOINT ["./start.sh"]
