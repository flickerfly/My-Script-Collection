#!/bin/bash
echo "########################"
echo "# Software on `hostname`"
echo "########################"

echo "## Linux Kernel:"
uname -a
echo ""

echo "## Apache"
apache2 -v 
echo ""

echo "## MySQL"
mysql -V
echo ""

echo "## PHP"
php -v --ini -re
echo ""

echo "## PostgreSQL"
/usr/local/pgsql/bin/psql --version
echo ""

echo "## PDFLib"
php -r "phpinfo();"|grep "PDFlib GmbH"
echo ""

echo "## Zend Framework"
ls /opt/|grep ZendFramework
echo ""

echo "## Suhosin"
php -r "phpinfo();"|grep -e "Suhosin [Extension|Patch]"
echo ""

echo "## CouchDB"
couchdb -V|head -1
echo ""

echo "## NICs"
#ifconfig -s
ifconfig|grep -e "eth\|inet addr\|lo"
echo ""

echo "## Users Added"
grep -e ":100[0-9]:" /etc/passwd
echo ""

echo "## File System Details"
df -h
echo ""

echo "## RAM"
free -m 
echo ""

echo "## Processors"
#cat /proc/cpuinfo | grep processor | wc -l
cat /proc/cpuinfo |grep "model name"|nl
echo ""
