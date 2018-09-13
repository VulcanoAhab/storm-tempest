#!/bin/bash

set -e

# Allow the container to be started with `--user`
if [ "$1" = 'storm' -a "$(id -u)" = '0' ]; then
    chown -R "$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"
    exec su-exec "$STORM_USER" "$0" "$@"
fi

if [ ! -z $ZOOKEEPER ];  then
  export ZOO=$ZOOKEEPER
else #kubernetes | [zookeeper] service
  if [ ! -z $ZOOKEEPER_SERVICE_HOST ]; then
    export ZOO=$ZOOKEEPER_SERVICE_HOST
  else
    export ZOO=""
  fi
fi

if [ ! -z $NIMBUS ];  then
  export NIM="nimbus.seeds: [\"$NIMBUS\"]"
else #kubernetes | [nimbus] service
  if [ ! -z $NIMBUS_SERVICE_HOST ]; then
    export NIM=$NIMBUS_SERVICE_HOST
  else
    export NIM=""
  fi
fi

# Generate the config  if it doesn't exist and update
CONFIG="$STORM_CONF_DIR/storm.yaml"
if [ ! -f "$CONFIG" ]; then
  cat >> "$CONFIG" <<EOF
storm.zookeeper.servers: [ $ZOO ]
nimbus.seeds: [ $NIM ]
storm.log.dir: "$STORM_LOG_DIR"
storm.local.dir: "$STORM_DATA_DIR"
supervisor.worker.timeout.secs: 600
nimbus.task.timeout.secs: 600
nimbus.supervisor.timeout.secs: 600
EOF
fi

echo "CONFIG SETTING ##################################"
cat $STORM_CONF_DIR/storm.yaml
echo "#################################################"
echo

exec "$@"
