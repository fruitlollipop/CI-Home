#!/usr/bin/env bash
current_dir=`pwd`
firefox_driver_version="0.19.1"
firefox_driver="geckodriver-v${firefox_driver_version}-linux64.tar.gz"
if [ ! -f $firefox_driver ]
then
  wget https://github.com/mozilla/geckodriver/releases/download/v${firefox_driver_version}/$firefox_driver
  tar zxf $firefox_driver
fi
chmod 777 $firefox_driver
export PATH=$PATH:$current_dir
robot -o /var/lib/jenkins/logs -v browser:firefox ${current_dir}/st_login_start_page.robot
exit 0
