#!/bin/sh
# by Josiah Ritchie <jritchie@crosslinkgroup.com>
# script assumes Ubuntu 14.04

# Must be run with root permissions 
# sudo will be sufficient

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt-get install libmemcached-dev nginx 

curl http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add - 
add-apt-repository 'http://dl.hhvm.com/ubuntu' 

apt-get update && apt-get install hhvm 

update-rc.d hhvm defaults 

/usr/share/hhvm/install_fastcgi.sh 
/etc/init.d/hhvm restart 
/etc/init.d/nginx restart 
