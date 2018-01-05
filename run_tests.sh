#!/usr/bin/bash
# python run_tests.py
uwsgi --ini Lollipop/myweb_uwsgi.ini
cp lollipopserver /etc/nginx/sites-available/
ln -n /etc/nginx/sites-available/lollipopserver /etc/nginx/sites-enabled/lollipopserver
# nginx -s reload
/etc/init.d/nginx restart