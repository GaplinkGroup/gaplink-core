#!/bin/sh

wget -O ntpclient_2015_365.tar.gz http://doolittle.icarus.com/ntpclient/ntpclient_2015_365.tar.gz
tar xvf ntpclient_2015_365.tar.gz
cd ntpclient-2015
make
cp ntpclient /usr/local/bin/
chmod a+x /usr/local/bin/ntpclient