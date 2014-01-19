#!/bin/bash
# A sample UNIX script that can be used to stop cc_dashboard from
# init.d/cron
if [ -f /usr/bin/lsof ]
then
    LSOF=/usr/bin/lsof
elif [ -f /usr/sbin/lsof ]
then
    LSOF=/usr/sbin/lsof
else
	echo "Could not find location of lsof"
	exit 1
fi

CC_DASHBOARD_PID=`$LSOF -i TCP:3332|grep -v PID|awk '{print $2}'`
if [ "x$CC_DASHBOARD_PID" != "x" ]; then
    echo "Killing cc_dashboard PID $CC_DASHBOARD_PID"
    kill $CC_DASHBOARD_PID
    sleep 3
fi
