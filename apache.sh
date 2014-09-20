#!/bin/bash

exec /usr/sbin/apache2ctl start >>/var/log/apache2ctl 2>&1
