# ==========================================================
# Rootless Docker Configuration
# ==========================================================

# Set DOCKER_HOST for rootless Docker if the socket exists
if [[ -S "$XDG_RUNTIME_DIR/docker.sock" ]]; then
  export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
fi
