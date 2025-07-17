FROM ubuntu:rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_VERSION=2.326.0
ENV RUNNER_ARCH=linux-x64
ENV RUNNER_DIR=/actions-runner

# Install required tools
RUN apt-get update && \
    apt-get install -y \
    curl jq git sudo unzip lsb-release gnupg \
    ca-certificates software-properties-common \
    iproute2 iptables uidmap \
    libseccomp2 dotnet-sdk-9.0 \
    docker.io && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create working directory
RUN mkdir -p $RUNNER_DIR
WORKDIR $RUNNER_DIR

# Download GitHub Actions Runner
RUN curl -o actions-runner.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    echo "9c74af9b4352bbc99aecc7353b47bcdfcd1b2a0f6d15af54a99f54a0c14a1de8  actions-runner.tar.gz" | shasum -a 256 -c && \
    tar xzf actions-runner.tar.gz && rm actions-runner.tar.gz

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Add runner user
RUN useradd -m runner && usermod -aG docker runner && chown -R runner:runner $RUNNER_DIR

# Default user is root (important for Docker)
# USER root

ENTRYPOINT ["/entrypoint.sh"]
