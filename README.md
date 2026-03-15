# hermit

Docker Sandboxes custom templates let you create reusable sandbox environments with pre-installed tools and configuration. Instead of asking the agent to install packages each time, hermit is built with everything ready for OpenClaw on Ollama.

hermit is a shell-first template based on `docker/sandbox-templates:shell` with Node.js 22, Ollama, OpenClaw, and `zstd` preinstalled. On first interactive run, it starts `ollama serve`, bootstraps OpenClaw config for sandbox constraints, and launches OpenClaw.

## Quick Start

```bash
docker build -t hermit .
```

```bash
docker sandbox run --name seashell -t hermit shell .
```

```bash
docker sandbox run seashell
```

## Build Without Cloning

```bash
docker build -t hermit https://github.com/alDuncanson/hermit.git
```
