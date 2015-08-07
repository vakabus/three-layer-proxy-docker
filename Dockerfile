FROM gliderlabs/alpine:3.2
MAINTAINER mhiro2 <clover.jd@gmail.com>

ENV ZIPROXY_VERSION ziproxy-3.3.1
ENV SQUID_CACHE_DIR /var/spool/squid

COPY privoxy/config /etc/privoxy/config
COPY ziproxy/ziproxy.conf /etc/ziproxy/ziproxy.conf
COPY squid/squid.conf /etc/squid/squid.conf

# packages
RUN apk --update add privoxy squid libjpeg libpng libjasper zlib-dev libsasl giflib supervisor \
 && rm -rf /var/cache/apk/* \
 && mkdir ${SQUID_CACHE_DIR} \
 && chown squid:squid ${SQUID_CACHE_DIR}
RUN cd /usr/lib \
 && ls -l | awk '$9 ~ /^lib.*.so.[0-9\.]{5}$/ {x=$9; gsub(/\.[0-9\.]+$/, "", x); print $9, x}' | xargs -n2 ln -sf \
 && ls -l | awk '$9 ~ /^libpng[0-9]{2}.so.[0-9]{2}$/ {x=$9; gsub(/[0-9]+\.so\.[0-9]+$/, ".so", x); print $9, x}' | xargs -n2 ln -sf

# ziproxy
COPY ziproxy/ziproxy.patch /tmp/ziproxy.patch
RUN apk --update add g++ make jasper-dev cyrus-sasl-dev giflib-dev jpeg-dev libpng-dev \
 && wget http://nchc.dl.sourceforge.net/project/ziproxy/ziproxy/${ZIPROXY_VERSION}/${ZIPROXY_VERSION}.tar.bz2 -P /tmp \
 && tar jxf /tmp/${ZIPROXY_VERSION}.tar.bz2 -C /tmp \
 && cd /tmp/${ZIPROXY_VERSION} \
 && patch -p1 < /tmp/ziproxy.patch \
 && ./configure \
 && make \
 && make install \
 && cd /tmp \
 && rm -rf ziproxy* \
 && apk del gcc g++ make libpng-dev jpeg-dev giflib-dev cyrus-sasl-dev jasper-dev

# supervisor
COPY supervisor.conf /etc/supervisor.d/supervisor.ini

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
