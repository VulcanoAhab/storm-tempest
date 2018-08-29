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

if [ ! -z $ZOOKEEPER ];  then
  echo "storm.zookeeper.servers:[\"$ZOOKEEPER\"]" >> $CONFIG
else #kubernetes | [zookeeper] service
  if [ ! -z $ZOOKEEPER_SERVICE_HOST ]; then
    echo "storm.zookeeper.servers:[\"$ZOOKEEPER_SERVICE_HOST\"]" >> $CONFIG
  fi
fi

if [ ! -z $NIMBUS ];  then
  echo "nimbus.seeds:[\"$NIMBUS\"]" >> $CONFIG
else #kubernetes | [nimbus] service
  if [ ! -z $NIMBUS_SERVICE_HOST ]; then
    echo "nimbus.seeds:[\"$NIMBUS_SERVICE_HOST\"]" >> $CONFIG
  fi
fi

cat  >> "$CONFIG" << EOF
storm.log.dir: "$STORM_LOG_DIR"
storm.local.dir: "$STORM_DATA_DIR"
EOF

echo "CONFIG SETTING ##################################"
cat $STORM_CONF_DIR/storm.yaml
echo "#################################################"
echo

exec "$@"
