# sand-crab

Minimal shell-based Docker sandbox for running OpenClaw with Ollama.

## Build Image

```bash
docker build -t sand-crab .
```

## Build From GitHub (No Clone)

```bash
docker build -t sand-crab https://github.com/alDuncanson/sand-crab.git
```

```bash
docker run -it --rm sand-crab
```

## Create Sandbox

```bash
docker sandbox run --name shell-sandboxing -t sand-crab shell .
```

## Recreate Sandbox

```bash
docker sandbox rm shell-sandboxing
```

```bash
docker sandbox run --name shell-sandboxing -t sand-crab shell .
```

## Start Sandbox Session

```bash
docker sandbox run shell-sandboxing
```

The shell autostarts `ollama serve`, bootstraps OpenClaw config (first run), and launches OpenClaw.

## Use A Different Model

```bash
OPENCLAW_MODEL=kimi-k2.5:cloud docker sandbox run shell-sandboxing
```

## Skip Autostart Once

```bash
OPENCLAW_AUTOSTART=0 docker sandbox run shell-sandboxing
```

## Run As A Normal Docker Container

```bash
docker run -it --rm sand-crab
```

```bash
docker run -it --rm -e OPENCLAW_AUTOSTART=0 sand-crab
```

## Troubleshooting

```bash
tail -n 120 /tmp/ollama-serve.log
```

```bash
tail -n 200 /tmp/openclaw-onboard.log
```

```bash
ollama launch openclaw --verbose
```

If sandbox networking is in deny mode, allow Ollama hosts:

```bash
docker sandbox network proxy shell-sandboxing --allow-host ollama.com --allow-host registry.ollama.ai
```
