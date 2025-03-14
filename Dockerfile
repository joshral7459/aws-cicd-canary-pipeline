FROM httpd:2.4
COPY ./000-default.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
COPY ./html/ /usr/local/apache2/htdocs/
RUN echo "Include conf/extra/httpd-vhosts.conf" >> /usr/local/apache2/conf/httpd.conf
