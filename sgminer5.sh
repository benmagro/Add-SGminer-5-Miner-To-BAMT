#!/bin/sh
mine stop
sleep 5
cp config.patch /tmp/
cd /opt/miners/
git clone https://github.com/sgminer-dev/sgminer.git sgminer-5
cd /opt/miners/sgminer-5
git checkout v5_0
cp /opt/miners/sgminer-4.1.0-sph//ADL_SDK/* /opt/miners/sgminer-5/ADL_SDK/
make clean
sleep 5
chmod +x autogen.sh
./autogen.sh
sleep 2
CFLAGS="-O2 -Wall -march=native -I /opt/AMDAPP/include/" LDFLAGS="-L/opt/AMDAPP/lib/x86" ./configure --enable-opencl
sleep 5
make install
sleep 5
clear
cp example.conf /etc/bamt/sgminer-5.conf
cd /etc/bamt/
patch /etc/bamt/bamt.conf <<.
116a117
>   cgminer_opts: --api-listen --config /etc/bamt/sgminer-5.conf
126a128
>   # Sgminer 5 - Multi-Algo
132a135
>   miner-sgminer-5: 1
.
patch /opt/bamt/common.pl <<.
1477a1478,1480
>       } elsif (\${\$conf}{'settings'}{'miner-sgminer-5'}) {
>         \$cmd = "cd /opt/miners/sgminer-5/;/usr/bin/screen -d -m -S sgminer-5 /opt/miners/sgminer-5/sgminer \$args";
>         \$miner = "sgminer-5";
.
cd /etc/bamt/
mv /tmp/config.patch /etc/bamt/
cd /etc/bamt/
patch /etc/bamt/sgminer-5.conf < config.patch
rm config.patch
sync
echo 'SGMiner 5 Installed.'
echo 'Please review your /etc/bamt/bamt.conf to enable.'
echo 'Configure /etc/bamt/sgminer-5.conf with a pool'
