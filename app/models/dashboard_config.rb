class DashboardConfig

  #cattr_accessor :cctray_feed_urls, :instance_writer => false
  #@@cctray_feed_urls = {}

  cattr_accessor :servers, :instance_writer => false
  @@servers = []

  cattr_accessor :servers_hash, :instance_writer => false
  @@servers_hash = {}

  cattr_accessor :http_open_timeout, :instance_writer => false
  @@cctray_feed_open_timeout = 10

  cattr_accessor :http_read_timeout, :instance_writer => false
  @@cctray_feed_read_timeout = 10

  cattr_accessor :refresh_interval, :instance_writer => false
  @@refresh_interval = 60.seconds

  cattr_accessor :bling, :instance_writer => false
  @@bling = []

  cattr_accessor :skin, :instance_writer => false
  @@skin = 'doom'

  cattr_accessor :track, :instance_writer => false
  @@track = ''

  cattr_accessor :alarm, :instance_writer => false
  @@alarm = []

  cattr_accessor :widgets, :instance_writer => false
  @@widgets = {}

end
