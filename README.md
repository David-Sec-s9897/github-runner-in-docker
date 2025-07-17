# 📦 GitHub Actions Self-Hosted Runner (Docker-Based)

This image provides a **self-hosted GitHub Actions runner** running on **Ubuntu (rolling)** with **Docker** support.  
It runs the **GitHub runner as a non-root user**, while **Docker runs as root**, enabling workflows to safely access Docker commands.

---

## 📸 Image

```
quay.io/davidsec/github-runner:latest
```

---

## 🚀 Features

- ✅ Based on `ubuntu:rolling`
- ✅ GitHub Actions Runner `v2.326.0`
- ✅ Docker daemon preinstalled and launched as root
- ✅ Runner executed as non-root user `runner`
- ✅ Secure access to Docker via mounted host socket or DinD

---

## 🛠️ Usage

### 🔐 Prerequisites

- GitHub repository
- Runner registration token from your GitHub repo/settings:
  - **Settings → Actions → Runners → New self-hosted runner**

---

### 🧪 Run with Host Docker Socket (Recommended)

```bash
docker run -d \
  -e REPO_URL=https://github.com/YOUR_ORG/YOUR_REPO \
  -e RUNNER_TOKEN=YOUR_RUNNER_TOKEN \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name github-runner \
  quay.io/davidsec/github-runner:latest
```

> ✅ Replace `REPO_URL` and `RUNNER_TOKEN` with your actual values.

---

### 🔥 Run with Docker-in-Docker (Privileged Mode)

```bash
docker run -d --privileged \
  -e REPO_URL=https://github.com/YOUR_ORG/YOUR_REPO \
  -e RUNNER_TOKEN=YOUR_RUNNER_TOKEN \
  --name github-runner \
  quay.io/davidsec/github-runner:latest
```

---

## 🧾 Environment Variables

| Variable      | Required | Description                            |
|---------------|----------|----------------------------------------|
| `REPO_URL`    | ✅       | Your GitHub repo URL                   |
| `RUNNER_TOKEN`| ✅       | GitHub registration token              |

---

## 🔍 Debug / Verify

Once running:

```bash
docker logs -f github-runner
```

You should see:
- Docker daemon starting
- Runner registering successfully
- The runner showing online in your repo’s "Actions → Runners" tab

---

## 📄 Example Workflow

```yaml
jobs:
  build:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v3
      - run: docker version
```

---

## 🛡️ Security Notes

- The runner runs as non-root (`runner`)
- Docker is executed via the Docker socket or DinD
- Be cautious running untrusted workflows with `--privileged`

---
