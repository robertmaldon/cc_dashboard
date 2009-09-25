class DashboardConfig

  cattr_accessor :cctray_feed_urls, :instance_writer => false
  @@cctray_feed_urls = {}

  cattr_accessor :cctray_feed_open_timeout, :instance_writer => false
  @@cctray_feed_open_timeout = 10

  cattr_accessor :cctray_feed_read_timeout, :instance_writer => false
  @@cctray_feed_read_timeout = 10

  cattr_accessor :refresh_interval, :instance_writer => false
  @@refresh_interval = 60.seconds

  cattr_accessor :theme, :instance_writer => false
  @@theme = 'smiley'

end