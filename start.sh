#!/bin/bash
# A sample UNIX script that can be used to start cc_dashboard from
# init.d/cron
cd `dirname $0`
bundle exec unicorn_rails -c config/unicorn.rb -E production -D
