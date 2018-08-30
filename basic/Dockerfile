FROM storm:1.1

COPY storm-supervisor-entrypoint.sh /
RUN chown storm:storm /storm-supervisor-entrypoint.sh
RUN chmod u+x /storm-supervisor-entrypoint.sh

EXPOSE 3772 6627 6700 6701 6702 6703 8080

ENTRYPOINT ["/storm-supervisor-entrypoint.sh"]
