FROM ubuntu:20.04 as ubuntu-base

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
        sudo \
        supervisor \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY scripts/* /opt/bin/

# Add Supervisor configuration file
COPY supervisord.conf /etc/supervisor/

# Relaxing permissions for other non-sudo environments
RUN  mkdir -p /var/run/supervisor /var/log/supervisor \
    && chmod -R 777 /opt/bin/ /var/run/supervisor /var/log/supervisor /etc/passwd \
    && chgrp -R 0 /opt/bin/ /var/run/supervisor /var/log/supervisor \
    && chmod -R g=u /opt/bin/ /var/run/supervisor /var/log/supervisor


CMD ["/opt/bin/entry_point.sh"]

#============================
# Utilities
#============================
FROM ubuntu-base as ubuntu-utilities
RUN apt-get install -y --no-install-recommends \
        wget \
        bash \
        gcc \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*





