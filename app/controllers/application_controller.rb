# Load application configuration, if it exists
load "#{Rails.root}/config/cc_dashboard_config.rb" if File.exists?("#{Rails.root}/config/cc_dashboard_config.rb")

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  protect_from_forgery
end
