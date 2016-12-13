From mitmproxy/mitmproxy
EXPOSE 8080
RUN apk add --no-cache zsh
RUN apk add --no-cache perl
RUN apk add --no-cache apache2
RUN mkdir /run/apache2
COPY mitmproxy-ca-cert.cer mitmproxy-ca-cert.pem mitmproxy-dhparam.pem mitmproxy-ca-cert.p12 mitmproxy-ca.pem /tmp/
COPY time.sh /usr/local/bin
CMD chmod 755 /usr/local/bin/time.sh
COPY index.cgi /var/www/localhost/cgi-bin
CMD chmod 755 /var/www/localhost/cgi-bin/index.cgi
COPY index.html /var/www/localhost/htdocs
COPY title.png play.png stop.png timewarp.png /var/www/localhost/htdocs/
COPY httpd.conf /etc/apache2/httpd.conf
COPY entrypoint.sh /usr/local/bin
CMD chmod 755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
