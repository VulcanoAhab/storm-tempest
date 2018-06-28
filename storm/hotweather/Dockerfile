FROM openjdk:8-jre-alpine

#Install tempest required packages
##python3
RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache
##chrome drive
RUN apk update && \
	apk add curl unzip libexif udev chromium chromium-chromedriver
##streamparse
RUN apk add --no-cache \
  python3-dev \
  gcc \
  libffi \
  libffi-dev \
  make \
  libc-dev \
  openssl-dev
##lxml
RUN echo \
  # replacing default repositories with edge ones
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk add --no-cache libxml2-dev libxslt-dev

#Create tempest virtualenv
RUN pip install virtualenv && \
    mkdir -p /data/virtualenvs && \
    cd /data/virtualenvs && \
    virtualenv tempest

# Install storm required packages
RUN apk add --no-cache \
    bash \
    python \
    su-exec

#Log
RUN mkdir -p /var/log/storm/streamparse/
RUN chown -R storm:storm /var/log/storm/

#storm
ENV STORM_USER=storm \
    STORM_CONF_DIR=/conf \
    STORM_DATA_DIR=/data \
    STORM_LOG_DIR=/logs

# Add a user and make dirs
RUN set -ex; \
    adduser -D "$STORM_USER"; \
    mkdir -p "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"; \
    chown -R "$STORM_USER:$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"``

ARG GPG_KEY=ACEFE18DD2322E1E84587A148DE03962E80B8FFD
ARG DISTRO_NAME=apache-storm-1.2.2

# Download Apache Storm, verify its PGP signature, untar and clean up
RUN set -ex; \
    apk add --no-cache --virtual .build-deps \
      gnupg; \
    wget -q "http://www.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz"; \
    wget -q "http://www.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY"; \
    gpg --batch --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz"; \
    tar -xzf "$DISTRO_NAME.tar.gz"; \
    chown -R "$STORM_USER:$STORM_USER" "$DISTRO_NAME"; \
    rm -rf "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc"; \
    apk del .build-deps

WORKDIR $DISTRO_NAME

ENV PATH $PATH:/$DISTRO_NAME/bin

#Install requirements
RUN . /data/virtualenvs/tempest/bin/activate && \
pip install streamparse && \
pip install https://github.com/VulcanoAhab/pyBrows/archive/master.zip


COPY storm-supervisor-entrypoint.sh /
RUN chown storm:storm /storm-supervisor-entrypoint.sh
RUN chmod u+x /storm-supervisor-entrypoint.sh

ENTRYPOINT ["/storm-supervisor-entrypoint.sh"]
