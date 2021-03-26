FROM linuxserver/domoticz:latest

ENV SBFSPOTDIR=/opt/sbfspot
ENV SMADATA=/var/smadata

RUN apt-get update && apt-get install -y \
  apt-transport-https \
  sqlite3 \
  libsqlite3-dev \
  make \
  libboost-all-dev \
  g++ \
  patch \
  bluez libbluetooth-dev

ADD dist/SBFspot*.tar.gz /sbfspot.3/
ADD dist/misc.patch /sbfspot.3/misc.patch
ADD dist/sma.cron /sma.cron
COPY dist/entry.sh /entry.sh
RUN chmod 755 /entry.sh
RUN /usr/bin/crontab /sma.cron


WORKDIR /sbfspot.3/SBFspot
RUN patch -p1 -i ../misc.patch
RUN make install_sqlite

WORKDIR /

RUN mkdir -p $SBFSPOTDIR && \
    mkdir -p $SMADATA

RUN mv /usr/local/bin/sbfspot.3/* $SBFSPOTDIR && \
    cp /sbfspot.3/SBFspot/CreateSQLiteDB.sql $SBFSPOTDIR && \
    rm -rf /sbfspot.3

RUN sqlite3 $SMADATA/SBFspot.db < $SBFSPOTDIR/CreateSQLiteDB.sql

RUN apt-get clean g++ make

ENTRYPOINT ["/entry.sh"]
