FROM gliderlabs/alpine:3.2
MAINTAINER mhiro2 <clover.jd@gmail.com>

# privoxy & squid & packages (for ziproxy)
RUN apk --update add privoxy squid libjpeg libpng libjasper zlib-dev libsasl giflib && rm -rf /var/cache/apk/*
RUN cd /usr/lib \
 && ls -l | awk '$9 ~ /^lib.*.so.[0-9\.]{5}$/ {x=$9; gsub(/\.[0-9\.]+$/, "", x); print $9, x}' | xargs -n2 ln -sf \
 && ls -l | awk '$9 ~ /^libpng[0-9]{2}.so.[0-9]{2}$/ {x=$9; gsub(/[0-9]+\.so\.[0-9]+$/, ".so", x); print $9, x}' | xargs -n2 ln -sf

# TODO: privoxy/config must be edited!!!
# COPY privoxy/config /etc/privoxy/config

# TODO: ziproxy/ziproxy.conf must be edited!!!
# COPY ziproxy/ziproxy.conf /etc/ziproxy/ziproxy.conf

# TODO: squid/squid.conf must be edited!!!
# COPY squid/squid.conf /etc/squid/squid.conf

# ziproxy
COPY ziproxy/ziproxy.patch /tmp/ziproxy.patch
RUN apk --update add g++ make jasper-dev cyrus-sasl-dev giflib-dev jpeg-dev libpng-dev \
 && wget http://nchc.dl.sourceforge.net/project/ziproxy/ziproxy/ziproxy-3.3.1/ziproxy-3.3.1.tar.bz2 -P /tmp \
 && tar jxf /tmp/ziproxy-3.3.1.tar.bz2 -C /tmp \
 && cd /tmp/ziproxy-3.3.1 \
 && patch -p1 < /tmp/ziproxy.patch \
 && ./configure \
 && make \
 && make install \
 && cd /tmp \
 && rm -rf ziproxy* \
 && apk del gcc g++ make libpng-dev jpeg-dev giflib-dev cyrus-sasl-dev jasper-dev

# supervisor
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

CMD ["/usr/bin/supervisord"]
