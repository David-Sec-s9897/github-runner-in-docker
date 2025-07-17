#!/bin/bash
set -e

echo "🔧 Starting Docker daemon..."
# Start Docker in background
dockerd > /var/log/dockerd.log 2>&1 &

# Wait for Docker daemon to be ready
echo "⏳ Waiting for Docker daemon to be ready..."
timeout 30 bash -c 'until docker info >/dev/null 2>&1; do sleep 1; done'

echo "✅ Docker is running."

if [ -z "$REPO_URL" ] || [ -z "$RUNNER_TOKEN" ]; then
  echo "❌ Missing REPO_URL or RUNNER_TOKEN"
  exit 1
fi

cd /actions-runner

# Configure GitHub runner as the non-root user
echo "⚙️ Configuring GitHub runner as 'runner' user..."
su - runner -c "cd /actions-runner && ./config.sh --unattended --url $REPO_URL --token $RUNNER_TOKEN --name $(hostname) --work _work"

# Run the GitHub runner as non-root
echo "🚀 Starting GitHub Actions runner as 'runner'..."
exec su - runner -c "cd /actions-runner && ./run.sh"
