# hermit

`hermit` is a custom Docker Sandbox template for running OpenClaw via Ollama in an isolated micro VM with its own Docker daemon.

> [why docker sandboxes](https://docs.docker.com/ai/sandboxes/#why-use-docker-sandboxes)? 

## Quick Start

### Build Image Locally

Build the `hermit` template image from this repository.

```bash
docker build -t hermit .
```

### Create The Sandbox

Create and start a sandbox named `seashell` using the `hermit` template.

```bash
docker sandbox run --name seashell -t hermit shell .
```

### Reconnect To Sandbox

Start another session in the existing `seashell` sandbox.

```bash
docker sandbox run seashell
```

## Build Without Cloning

### Build Directly From GitHub

Build the image from the repository URL without cloning locally.

```bash
docker build -t hermit https://github.com/alDuncanson/hermit.git
```
