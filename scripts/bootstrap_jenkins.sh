#!/bin/bash

mkfs -t ext4 /dev/sdb
mkdir /data
mount /dev/sdb /data
echo "/dev/sdb       /data   ext4    defaults,nofail        0       2" >> /etc/fstab

