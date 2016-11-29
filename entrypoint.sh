#!/bin/zsh

MITMPROXY_PATH="/home/mitmproxy/.mitmproxy"
echo 127.0.0.1 hack hack.com >> /etc/hosts
mkdir -p "$MITMPROXY_PATH"
chown -R mitmproxy:mitmproxy "$MITMPROXY_PATH"
echo -n 0 > /tmp/timewarp
chown mitmproxy:mitmproxy /tmp/timewarp

/usr/sbin/httpd -f /etc/apache2/httpd.conf

while sleep .2
do
    timewarp=$(cat /tmp/timewarp)
    su-exec mitmproxy mitmproxy --replace '&https://cloud.rovio.com/identity/2.0/time&({"time":.*?)[0-9]*}&\g<1>'$(($(date +%s)+$timewarp*3600))'}'
done
