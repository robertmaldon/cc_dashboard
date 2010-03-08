#!/bin/bash
# A sample UNIX script that can be used to start cc_dashboard from
# init.d/cron
cd `dirname $0`
nohup script/server > /tmp/cc_dashboard_stdout 2>/tmp/cc_dashboard_stderr &
