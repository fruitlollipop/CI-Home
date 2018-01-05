#!/usr/bin/bash
# python run_tests.py
cp lollipopserver /etc/nginx/sites-available/
ln -n /etc/nginx/sites-available/lollipopserver /etc/nginx/sites-enabled/lollipopserver
nginx -s reload