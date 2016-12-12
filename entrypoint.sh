#!/bin/zsh

MITMPROXY_PATH="/home/mitmproxy/.mitmproxy"

echo 127.0.0.1 hack hack.com >> /etc/hosts

mkdir -p "$MITMPROXY_PATH"
chown -R mitmproxy:mitmproxy "$MITMPROXY_PATH"

date +%s > /tmp/timewarp
cp /tmp/timewarp /tmp/timewarp.value
chown mitmproxy:mitmproxy /tmp/timewarp /tmp/timewarp.value

echo -n P > /tmp/state
chown mitmproxy:mitmproxy /tmp/state

/usr/sbin/httpd -f /etc/apache2/httpd.conf

nohup /usr/local/bin/time.sh > /dev/null 2>&1 &

while sleep .2
do
    timewarp=$(cat /tmp/timewarp.value)

     su-exec mitmproxy mitmproxy --replace '&https://cloud.rovio.com/identity/2.0/time&({"time":.*?)[0-9]*}&\g<1>'$timewarp'}'
    
#    su-exec mitmproxy mitmproxy --replace '&https://cloud.rovio.com/identity/2.0/time&({"time":.*?)[0-9]*}&\g<1>'$(($(date +%s)+$timewarp*3600))'}'
done
