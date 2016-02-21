three-layer-proxy-docker
========================

Small Docker container with [Squid](http://www.squid-cache.org/), [Ziproxy](http://ziproxy.sourceforge.net/) and [Privoxy](http://www.privoxy.org/) based on Alpine Linux.

~~~
REPOSITORY                  TAG         IMAGE ID        VIRTUAL SIZE
mhiro2/three-layer-proxy    latest      e1ef1ff1c8ce    61.55 MB
~~~


Usage
---

Squid proxy is configured to accept any connections from local network IPs. Just make sure your IP matches one of the masks in [squid's config file](squid/squid.conf).

~~~
$ docker pull mhiro2/three-layer-proxy
$ docker run -p 3128:3128 mhiro2/three-layer-proxy
~~~

Reference
---
http://blog.asial.co.jp/1076
