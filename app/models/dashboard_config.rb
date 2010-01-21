class DashboardConfig

  cattr_accessor :cctray_feed_urls, :instance_writer => false
  @@cctray_feed_urls = {}

  cattr_accessor :cctray_feed_open_timeout, :instance_writer => false
  @@cctray_feed_open_timeout = 10

  cattr_accessor :cctray_feed_read_timeout, :instance_writer => false
  @@cctray_feed_read_timeout = 10

  cattr_accessor :refresh_interval, :instance_writer => false
  @@refresh_interval = 60.seconds

  cattr_accessor :show_chuck_norris_facts, :instance_writer => false
  @@show_chuck_norris_facts = true

  cattr_accessor :skin, :instance_writer => false
  @@skin = 'doom'

end
