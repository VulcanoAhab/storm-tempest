FROM storm

#storm config
RUN mkdir -p $STORM_CONF_DIR
COPY ./conf/storm.yaml $STORM_CONF_DIR
RUN chown storm:storm $STORM_CONF_DIR/storm.yaml

COPY storm-supervisor-entrypoint.sh /
RUN chown storm:storm /storm-supervisor-entrypoint.sh
RUN chmod u+x /storm-supervisor-entrypoint.sh

EXPOSE 3772 6627 6700 6701 6702 6703 8080

ENTRYPOINT ["/storm-supervisor-entrypoint.sh"]
