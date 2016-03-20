FROM debian:8
MAINTAINER Dominique Barton

#
# Add SickBeard init script.
#

COPY assets/scripts/sickbeard.sh /opt/sickbeard.sh

#
# Install SickBeard and all required dependencies.
#

RUN apt-get -qq update \
    && apt-get install -yf curl            \
                           ca-certificates \
                           python-cheetah  \
                           python-openssl  \
                           git             \
    && apt-get -y autoremove               \
    && apt-get -y clean                    \
    && rm -rf /var/lib/apt/lists/*

RUN git clone git://github.com/midgetspy/Sick-Beard.git /sickbeard

#
# Start SickBeard.
#

ENTRYPOINT ["/opt/sickbeard.sh"]
