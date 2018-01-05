#!/usr/bin/env bash
uwsgi --ini /app/CI-Home/Lollipop/myweb_uwsgi.ini

cp lollipopserver /etc/nginx/sites-available/
chmod 644 /etc/nginx/sites-available/lollipopserver
ln -s /etc/nginx/sites-available/lollipopserver /etc/nginx/sites-enabled/lollipop

/etc/init.d/nginx restart