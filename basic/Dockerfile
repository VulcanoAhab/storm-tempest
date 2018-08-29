FROM storm

#storm config
RUN mkdir -p $STORM_CONF_DIR
COPY ./conf/storm.yaml $STORM_CONF_DIR
RUN chown storm:storm $STORM_CONF_DIR/storm.yaml

COPY storm-supervisor-entrypoint.sh /
RUN chown storm:storm /storm-supervisor-entrypoint.sh
RUN chmod u+x /storm-supervisor-entrypoint.sh

ENTRYPOINT ["/storm-supervisor-entrypoint.sh"]
