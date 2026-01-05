set -euo pipefail
IFS=$'\n\t'


PODMAN_DIR=$( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd )
PROJECT_DIR=$( dirname "$PODMAN_DIR" )
echo "$PODMAN_DIR"
echo "$PROJECT_DIR"

# Database
podman build \
  --tag web-counter-db \
  --file "$PODMAN_DIR/Containerfile-database" \
  "$PROJECT_DIR/database"

# API
podman build \
  --tag web-counter-api \
  --file "$PODMAN_DIR/Containerfile-api" \
  "$PROJECT_DIR/api"

# Frontend
podman build \
  --tag web-counter-frontend \
  --file "$PODMAN_DIR/Containerfile-frontend" \
  "$PROJECT_DIR/frontend"
