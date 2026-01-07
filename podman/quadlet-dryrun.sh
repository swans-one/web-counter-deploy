set -euo pipefail
IFS=$'\n\t'

/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun
