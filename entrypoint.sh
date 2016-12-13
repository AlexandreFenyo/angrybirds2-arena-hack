#!/bin/zsh

# a enlever dans docker
export PYTHONHOME=/usr/local/ansible:/usr/local/ansible/bin:/home/fenyo/install/apache-maven-3.3.9/bin:/usr/sbin:/usr/bin:/sbin:/bin

MITMPROXY_PATH="/home/mitmproxy/.mitmproxy"

echo 127.0.0.1 hack hack.com www.hack.com >> /etc/hosts

mkdir -p "$MITMPROXY_PATH"
chown -R mitmproxy:mitmproxy "$MITMPROXY_PATH"

date +%s > /tmp/timewarp
echo 0 > /tmp/timewarp.value
chown mitmproxy:mitmproxy /tmp/timewarp /tmp/timewarp.value

echo -n S > /tmp/state
chown mitmproxy:mitmproxy /tmp/state

touch > /var/www/localhost/htdocs/msg.txt
chown mitmproxy:mitmproxy /var/www/localhost/htdocs/msg.txt

/usr/sbin/httpd -f /etc/apache2/httpd.conf

# a remettre avec docker
# nohup /usr/local/bin/time.sh > /dev/null 2>&1 &

while sleep .2
do
    timewarp=$(cat /tmp/timewarp.value)

    if [ $timewarp -eq 0 ]
    then
# a remettre en docker
	su-exec wwwrun mitmproxy
#	su-exec mitmproxy mitmproxy
    else
# a remettre en docker
	su-exec wwwrun mitmproxy --replace '&https://cloud.rovio.com/identity/2.0/time&({"time":.*?)[0-9]*}&\g<1>'$timewarp'}'
#	su-exec mitmproxy mitmproxy --replace '&https://cloud.rovio.com/identity/2.0/time&({"time":.*?)[0-9]*}&\g<1>'$timewarp'}'
    fi

    
#    su-exec mitmproxy mitmproxy --replace '&https://cloud.rovio.com/identity/2.0/time&({"time":.*?)[0-9]*}&\g<1>'$(($(date +%s)+$timewarp*3600))'}'
done
