FROM docker/sandbox-templates:shell

USER root

# Core tools needed for downloading and extracting provider assets.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    unzip \
    zstd \
    && rm -rf /var/lib/apt/lists/*

# OpenClaw requires Node 22+.
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama CLI/runtime in the sandbox image.
RUN curl -fsSL https://ollama.com/install.sh | sh

# Install OpenClaw CLI up-front so `ollama launch openclaw` does not prompt.
RUN npm install -g openclaw

# Auto-launch OpenClaw in interactive shell sessions. Set
# OPENCLAW_AUTOSTART=0 to disable for a specific session.
RUN cat <<'EOF' >/usr/local/bin/openclaw-autostart.sh
#!/usr/bin/env bash

OPENCLAW_DEFAULT_MODEL="${OPENCLAW_MODEL:-glm-5:cloud}"

ensure_ollama_server() {
  if ollama list >/dev/null 2>&1; then
    return 0
  fi

  echo "[openclaw-sandbox] Starting ollama server in background..."
  nohup ollama serve >/tmp/ollama-serve.log 2>&1 &

  for _ in {1..20}; do
    if ollama list >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done

  echo "[openclaw-sandbox] Ollama server did not become ready in time."
  echo "[openclaw-sandbox] Check logs with: tail -n 120 /tmp/ollama-serve.log"
  return 1
}

ensure_openclaw_config() {
  if [[ -f "$HOME/.openclaw/openclaw.json" ]]; then
    return 0
  fi

  echo "[openclaw-sandbox] Bootstrapping OpenClaw config (no systemd daemon in sandbox)..."
  if ! openclaw onboard --non-interactive \
    --flow quickstart \
    --auth-choice ollama \
    --custom-base-url "http://127.0.0.1:11434" \
    --custom-model-id "$OPENCLAW_DEFAULT_MODEL" \
    --accept-risk \
    --skip-health >/tmp/openclaw-onboard.log 2>&1; then
    echo "[openclaw-sandbox] OpenClaw onboarding failed."
    echo "[openclaw-sandbox] Check logs with: tail -n 200 /tmp/openclaw-onboard.log"
    return 1
  fi
}

if [[ -n "${OPENCLAW_AUTOSTART_RAN:-}" ]]; then
  return 0
fi
export OPENCLAW_AUTOSTART_RAN=1

if [[ "${OPENCLAW_AUTOSTART:-1}" != "1" ]]; then
  return 0
fi

if ! command -v ollama >/dev/null 2>&1; then
  return 0
fi

if ! command -v openclaw >/dev/null 2>&1; then
  return 0
fi

if ! ensure_ollama_server; then
  return 0
fi

if ! ensure_openclaw_config; then
  return 0
fi

echo "[openclaw-sandbox] Launching OpenClaw via Ollama (set OPENCLAW_AUTOSTART=0 to skip)."
echo "[openclaw-sandbox] Default model: ${OPENCLAW_DEFAULT_MODEL} (override with OPENCLAW_MODEL)."
ollama launch openclaw --model "$OPENCLAW_DEFAULT_MODEL"
EOF

RUN chmod +x /usr/local/bin/openclaw-autostart.sh

USER agent

RUN printf '\nsource /usr/local/bin/openclaw-autostart.sh\n' >> /home/agent/.bashrc
