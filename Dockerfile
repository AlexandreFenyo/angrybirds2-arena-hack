From mitmproxy/mitmproxy
RUN apk add --no-cache zsh
RUN apk add --no-cache apache2
RUN mkdir /run/apache2
COPY index.cgi /var/www/localhost/cgi-bin
CMD chmod 755 /var/www/localhost/cgi-bin/index.cgi
COPY index.html /var/www/localhost/htdocs
COPY httpd.conf /etc/apache2/httpd.conf
COPY entrypoint.sh /usr/local/bin
CMD chmod 755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
