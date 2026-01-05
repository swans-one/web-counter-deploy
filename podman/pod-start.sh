set -euo pipefail
IFS=$'\n\t'

if ! podman pod exists web-counter; then
    echo "Pod doesn't exist, create it first"
fi

podman pod start web-counter;
