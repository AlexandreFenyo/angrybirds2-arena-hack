#!/bin/zsh

DOCKER=false

if [ $DOCKER = false ]
then
    export PYTHONHOME=/usr/local/ansible:/usr/local/ansible/bin:/home/fenyo/install/apache-maven-3.3.9/bin:/usr/sbin:/usr/bin:/sbin:/bin
fi

MITMPROXY_PATH="/home/mitmproxy/.mitmproxy"

echo 127.0.0.1 hack hack.com www.hack.com >> /etc/hosts

mkdir -p "$MITMPROXY_PATH"
chown -R mitmproxy:mitmproxy "$MITMPROXY_PATH"

date +%s > /tmp/timewarp
echo -n 0 > /tmp/timewarp.value
chown mitmproxy:mitmproxy /tmp/timewarp /tmp/timewarp.value

echo -n S > /tmp/state
chown mitmproxy:mitmproxy /tmp/state

touch /var/www/localhost/htdocs/msg.txt
chown mitmproxy:mitmproxy /var/www/localhost/htdocs/msg.txt

/usr/sbin/httpd -f /etc/apache2/httpd.conf

if [ $DOCKER = true ]
then
    nohup /usr/local/bin/time.sh > /dev/null 2>&1 &
fi

while sleep .2
do
    cat /tmp/timewarp.value | read timewarp

    if [ $timewarp -eq 0 ]
    then
	su-exec wwwrun mitmproxy >> /tmp/res 2>&1
    else
	su-exec wwwrun mitmproxy --replace '&https://cloud.rovio.com/identity/2.0/time&({"time":.*?)[0-9]*}&\g<1>'$timewarp'}'
    fi
done

exit 1
