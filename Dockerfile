FROM silverbulleters/vanessa-32bit-baseclient
MAINTAINER Andranik Simonyan <andranik.s.s@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN linux32 add-apt-repository ppa:no1wantdthisname/ppa && linux32 apt-get update \
      && linux32 apt-get install -y vim dialog apache2 fontconfig-infinality \
      && apt-get autoclean -y  \
      && rm -rf /var/lib/apt/lists/*

ENV PLT_VERSION 8.3.10-2650
ENV PLT_ARCH i386
ENV LANG ru_RU.utf8

ADD ./dist/ /opt/
ADD ./start1C.sh /opt/
ADD ./dck1C.sh /opt/
# apache config
ADD ./config/money.conf etc/apache2/conf-enabled/
ADD ./config/ports.conf etc/apache2/

RUN dpkg -i /opt/1c-enterprise83-common_${PLT_VERSION}_${PLT_ARCH}.deb \
      /opt/1c-enterprise83-server_${PLT_VERSION}_${PLT_ARCH}.deb \
      /opt/1c-enterprise83-client_${PLT_VERSION}_${PLT_ARCH}.deb \
      /opt/1c-enterprise83-ws_${PLT_VERSION}_${PLT_ARCH}.deb \
      && unzip /opt/mscorefonts.zip -d /usr/share/fonts/TTF \
      && unzip /opt/ttf-fira-code.zip -d /usr/share/fonts/TTF \
      && unzip /opt/otf-fira-code.zip -d /usr/share/fonts/OTF \
      && unzip /opt/zukitwo-themes.zip -d /usr/share/themes \
      && unzip /opt/yltra-icons.zip -d /usr/share/icons \
      && unzip /opt/ultraflat-icons.zip -d /usr/share/icons \
      && rm /opt/*.deb && rm /opt/*.zip && chmod +x /opt/start1C.sh /opt/dck1C.sh \
      && /bin/bash /etc/fonts/infinality/infctl.sh setstyle linux

RUN cp /opt/backbas.so /opt/1C/v8.3/${PLT_ARCH}/backbas.so

RUN export uid=1000 gid=1000 && \
      mkdir -p /home/user && \
      echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
      echo "user:x:${uid}:" >> /etc/group && \
      echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
      chmod 0440 /etc/sudoers.d/user && \
      chown ${uid}:${gid} -R /home/user && \
      sed -i 's/www-data/user/g' /etc/apache2/envvars

USER user
ENV HOME /home/user

EXPOSE 8080

#CMD /opt/start1C.sh