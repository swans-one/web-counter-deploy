set -euo pipefail
IFS=$'\n\t'

if podman pod exists web-counter; then
    echo "Pod already exists, exiting."
    exit 0;
fi

podman pod create \
  --name web-counter \
  --publish 3000:3000 \
  --volume web-counter-db:/app/db

podman create \
  --pod web-counter \
  --name web-counter-db-init \
  --init-ctr=always \
  --env DATABASE_URL="sqlite:/app/db/database.sqlite3" \
  localhost/web-counter-db \
  up

podman create \
  --pod web-counter \
  --name web-counter-api-inpod \
  --env WEB_COUNTER_DB_PATH="/app/db/database.sqlite3" \
  localhost/web-counter-api

podman create \
  --pod web-counter \
  --name web-counter-frontend-inpod \
  localhost/web-counter-frontend
