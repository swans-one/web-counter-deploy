set -euo pipefail
IFS=$'\n\t'

WORK_DIR=$( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd )
UNITFILE_DEST_DIR="$HOME/.config/containers/systemd"

# Create the directory for unitfiles if it doesn't exist
mkdir -p $UNITFILE_DEST_DIR

# Copy all the unit files into that directory
cp $WORK_DIR/quadlet/* $UNITFILE_DEST_DIR

systemctl --user daemon-reload
