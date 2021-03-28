FROM debian

ENV SBFSPOTDIR=/opt/sbfspot
ENV SMADATA=/var/smadata

RUN apt-get update && apt-get install -y \
  apt-transport-https \
  wget \
  curl \
  make \
  gcc \
  g++ \
  libssl-dev \
  git \
  libcurl4-gnutls-dev \
  libusb-dev \
  python3-dev \
  zlib1g-dev \ 
  libcereal-dev \
  liblua5.3-dev \
  uthash-dev

RUN apt-get remove --auto-remove cmake

RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz
RUN tar -xzvf cmake-3.19.3.tar.gz
RUN rm cmake-3.19.3.tar.gz
RUN cd cmake-3.19.3
RUN ./bootstrap
RUN make
RUN make install
RUN cd ..
RUN rm -Rf cmake-3.19.3

RUN cmake --version

RUN mkdir boost
RUN cd boost
RUN wget https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.gz
RUN tar xfz boost_1_75_0.tar.gz
RUN cd boost_1_75_0/
RUN ./bootstrap.sh
RUN ./b2 stage threading=multi link=static --with-thread --with-system
RUN ./b2 install threading=multi link=static --with-thread --with-system
RUN cd ../../
RUN rm -Rf boost/

RUN cd open-zwave-read-only
RUN git pull
RUN make 
RUN make install

RUN git clone https://github.com/domoticz/domoticz.git dev-domoticz

RUN cd dev-domoticz
RUN git pull
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN make

#ADD dist/SBFspot*.tar.gz /sbfspot.3/
# dist/misc.patch /sbfspot.3/misc.patch
#ADD dist/sma.cron /sma.cron
#COPY dist/entry.sh /entry.sh
#RUN chmod 755 /entry.sh
#RUN /usr/bin/crontab /sma.cron


#WORKDIR /sbfspot.3/SBFspot
#RUN patch -p1 -i ../misc.patch
#RUN make install_sqlite

#WORKDIR /

#RUN mkdir -p $SBFSPOTDIR && \
#    mkdir -p $SMADATA

#RUN mv /usr/local/bin/sbfspot.3/* $SBFSPOTDIR && \
#    cp /sbfspot.3/SBFspot/CreateSQLiteDB.sql $SBFSPOTDIR && \
#    rm -rf /sbfspot.3

#RUN sqlite3 $SMADATA/SBFspot.db < $SBFSPOTDIR/CreateSQLiteDB.sql
#
#RUN apt-get clean g++ make
#
#ENTRYPOINT ["/entry.sh"]
