#!/usr/bin/env bash
uwsgi --ini /app/Lollipop/uwsgi.ini > /dev/null 2>&1 &

if [ ! -f "/etc/nginx/sites-available/lollipopserver" ]
then
  cp lollipopserver /etc/nginx/sites-available/
  chmod 644 /etc/nginx/sites-available/lollipopserver
fi
if [ ! -f "/etc/nginx/sites-enabled/lollipop" ]
then
  ln -s /etc/nginx/sites-available/lollipopserver /etc/nginx/sites-enabled/lollipop
fi

/etc/init.d/nginx restart

exit 0
