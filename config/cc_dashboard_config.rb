# This is a sample cc_dashboard configuration file

# List of cctray-formatted feed URLs. This is a Ruby hash where the key is
# a "group name" (an identifier for) and the value is a URL
DashboardConfig.cctray_feed_urls = {
  'CC.rb' => 'http://cruisecontrolrb.thoughtworks.com/XmlStatusReport.aspx',
  'CC.java' => 'http://cclive.thoughtworks.com/dashboard/cctray.xml',
  'CC.net' => 'http://ccnetlive.thoughtworks.com/ccnet/XmlStatusReport.aspx',
  'Huson' => 'http://deadlock.netbeans.org/hudson/cc.xml'
}

# If the cctray feeds regularly timeout then you may need to increase the
# default feed timeouts
#DashboardConfig.cctray_feed_open_timeout = 10
#DashboardConfig.cctray_feed_read_timeout = 10

# The number of seconds between browser page reloads
#DashboardConfig.refresh_interval = 60.seconds

# The bling. Currently available blings are 'cheezburger' and 'chucknorris'.
# Nobody stops Chuck Norris from kicking ass!
DashboardConfig.bling = 'cheezburger'
#DashboardConfig.bling = 'chucknorris'

# The skin. Currently available skins are 'doom', 'smiley', 'hudson'
# and 'kitten'
DashboardConfig.skin = 'spaceinvaders'
