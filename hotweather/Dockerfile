FROM storm


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

#Install requirements
COPY tempest.txt /tmp/
RUN source /data/virtualenvs/tempest/bin/activate && \
pip install -r /tmp/tempest.txt
RUN rm /tmp/tempest.txt

#log streamparse default
RUN mkdir -p /var/log/storm/streamparse/
RUN chown storm:storm /var/log/storm/streamparse/

#storm config
RUN mkdir -p $STORM_CONF_DIR
COPY ./conf/storm.yaml $STORM_CONF_DIR/
RUN chown storm:storm $STORM_CONF_DIR/storm.yaml


COPY storm-supervisor-entrypoint.sh /
RUN chown storm:storm /storm-supervisor-entrypoint.sh
RUN chmod u+x /storm-supervisor-entrypoint.sh

EXPOSE 3772 6627 6700 6701 6702 6703 8080


ENTRYPOINT ["/storm-supervisor-entrypoint.sh"]
