require 'rexml/document'
require 'net/http'
require 'uri'
require 'ostruct'
require 'json'

class DashboardController < ApplicationController

  before_filter :load_config
  
  def index
    @refresh = params[:refresh] || DashboardConfig.refresh_interval
  end

  def main
    @skin    = params[:skin]    || DashboardConfig.skin
    @track   = params[:track]   || DashboardConfig.track
    @refresh = params[:refresh] || DashboardConfig.refresh_interval
    @bling   = params[:bling]   || DashboardConfig.bling
    
    @activity_building = 0
    @status_failure    = 0
    @status_exception  = 0
    @status_success    = 0
    @status_unknown    = 0

    @projects = []
    DashboardConfig.cctray_feed_urls.each do |group_name, feed_url|
      doc = REXML::Document.new get_cctray_feed_xml(feed_url)
      doc.elements.each('Projects/Project') do |element|
        project = Project.new
        project.group_name = group_name
        project.populate_from_xml(element)
        @projects.push(project)

        case project.lastBuildStatus
        when 'Error' # 'Error' is our own status, not part of the cctray spec
          @status_exception += 1
        when 'Failure'
          @status_failure += 1
        when 'Exception'
          @status_exception += 1
        when 'Success'
          @status_success += 1
        when 'Unknown'
          @status_unknown += 1
        end

        @activity_building += 1 if project.activity == 'Building'
      end
    end

    DashboardConfig.jenkins_json_feed_urls.each do |group_name, feed_url|
    end

    if @activity_building > 0
      @status = 'building'
    elsif @status_failure > 0 || @status_exception > 0
      @status = 'sick'
    else
      @status = 'healthy'
    end

    @icon = "#{@status}.ico"

    @chuck_norris_fact = CHUCK_NORRIS_FACTS[rand(CHUCK_NORRIS_FACTS.length)]

    render :layout => nil
  end

  # A work-around for cross-domain permission issues when we can't use jasonp
  # TODO: Reject URLs that do not go to servers that we fetch cctray feeds from
  def proxy_xml
    xml = get_cctray_feed_xml(params[:xml_url])
    render :text => xml
  end

  private

  def get_cctray_feed_xml(feed_url)
    url = URI.parse(feed_url)
    begin
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.is_a?(URI::HTTPS)
      http.open_timeout = DashboardConfig.cctray_feed_open_timeout
      http.read_timeout = DashboardConfig.cctray_feed_read_timeout
      http.start do
        response = http.request_get(url.path)
        case response
          when Net::HTTPSuccess     then response.body
          when Net::HTTPRedirection then get_cctray_feed_xml(response['location'])
          else cctray_error_xml(feed_url, response.message)
        end
      end
    rescue Exception => e
      cctray_error_xml(feed_url, e.message)
    end
  end

  # To make the error handling logic simple put an error message inside a
  # cctray-formatted xml
  def cctray_error_xml(feed_url, message)
    error = <<EOF
<Projects>
  <Project name="#{message} [#{feed_url}]" activity="Error" lastBuildStatus="Error" lastBuildLabel="unknown" lastBuildTime="unknown" webUrl="#{feed_url}"/>
</Projects>
EOF
  end

  def get_all_jenkins_jobs(json_feed_url)
    url = URI.parse(json_feed_url)
    begin
      http = Net::HTTP.new(url.host, url.port)
      http.open_timeout = DashboardConfig.cctray_feed_open_timeout
      http.read_timeout = DashboardConfig.cctray_feed_read_timeout
      http.start do
        response = http.request_get(url.path)
        case response
          when Net::HTTPSuccess     then JSON.parse(response.body)
          when Net::HTTPRedirection then get_all_jenkins_jobs(response['location'])
          else {}
        end
      end
    rescue Exception => e
      {}
    end
  end

  def load_config
    load "#{Rails.root}/config/cc_dashboard_config.rb" if File.exists?("#{Rails.root}/config/cc_dashboard_config.rb")
  end

end
