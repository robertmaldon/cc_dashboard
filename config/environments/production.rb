# Settings specified here will take precedence over those in config/environment.rb

# NOTE - cc_dashboard uses many of the development setting here so that
# changes will be picked up dynamically
config.cache_classes = false

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
