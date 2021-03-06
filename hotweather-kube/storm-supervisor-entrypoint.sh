#!/bin/bash

set -e

# Allow the container to be started with `--user`
if [ "$1" = 'storm' -a "$(id -u)" = '0' ]; then
    chown -R "$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"
    exec su-exec "$STORM_USER" "$0" "$@"
fi

# Generate the config only if it doesn't exist
CONFIG="$STORM_CONF_DIR/storm.yaml"
if [ ! -f "$CONFIG" ]; then touch $STORM_CONF_DIR/storm.yaml; fi

cat  >> "$CONFIG" << EOF
storm.zookeeper.servers: [$ZOOKEEPER]
nimbus.seeds: [$NIMBUS]
storm.log.dir: "$STORM_LOG_DIR"
storm.local.dir: "$STORM_DATA_DIR"
EOF

cat $STORM_CONF_DIR/storm.yaml


exec "$@"
