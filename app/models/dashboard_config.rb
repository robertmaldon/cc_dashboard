class DashboardConfig

  cattr_accessor :cctray_feed_urls, :instance_writer => false
  @@cctray_feed_urls = {}

  cattr_accessor :cctray_feed_open_timeout, :instance_writer => false
  @@cctray_feed_open_timeout = 10

  cattr_accessor :cctray_feed_read_timeout, :instance_writer => false
  @@cctray_feed_read_timeout = 10

  cattr_accessor :refresh_interval, :instance_writer => false
  @@refresh_interval = 60.seconds

  cattr_accessor :bling, :instance_writer => false
  @@bling = 'chucknorris'

  cattr_accessor :skin, :instance_writer => false
  @@skin = 'doom'

end
