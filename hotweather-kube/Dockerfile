from mattf/storm-worker

#yum update
RUN yum -y update && \
yum -y install yum-utils

#python3
RUN yum -y install python3 \
python3-pip \
python3-devel
RUN if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi


##chrome drive
RUN yum -y install curl unzip libexif udev chromium chromium-chromedriver git

##streamparse
RUN yum -y install \
gcc \
libffi \
libffi-dev \
make \
libc-dev \
openssl-dev


#Create tempest virtualenv
RUN pip install virtualenv && \
  mkdir -p /data/virtualenvs && \
  cd /data/virtualenvs && \
  virtualenv tempest

# Install storm required packages
RUN yum -y install \
  bash \
  python \
  su-exec

#storm
ENV STORM_USER=storm \
STORM_CONF_DIR=/conf \
STORM_DATA_DIR=/data \
STORM_LOG_DIR=/logs

# Add a user and make dirs
RUN adduser "$STORM_USER"; \
mkdir -p "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"; \
chown -R "$STORM_USER:$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"``

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
COPY ./conf/storm.yaml $STORM_CONF_DIR
RUN chown storm:storm $STORM_CONF_DIR/storm.yaml

COPY storm-supervisor-entrypoint.sh /
RUN chown storm:storm /storm-supervisor-entrypoint.sh
RUN chmod u+x /storm-supervisor-entrypoint.sh

ENTRYPOINT ["/storm-supervisor-entrypoint.sh"]
