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
    
    @activity_building = 0
    @status_failure    = 0
    @status_exception  = 0
    @status_success    = 0
    @status_unknown    = 0

    @projects = []
    DashboardConfig.servers.each do |server|
      feed_url = server[:base_url]
      feed_url = "#{feed_url}/" unless feed_url.match(/\/$/)
      feed_url = feed_url + server[:cctray_path]

      doc = REXML::Document.new get_cctray_feed_xml(feed_url, server[:user], server[:password])
      if server[:type] != :bamboo
        doc.elements.each('Projects/Project') do |element|
          project = Project.new
          project.group_name = server[:id]
          project.server = server
          project.populate_from_xml(element)
          @projects.push(project)
        end
      else
        projects_hash = Hash.new
        doc.elements.each('rss/channel/item') do |element|
          project = Project.new
          project.group_name = server[:id]
          project.server = server

          project.populate_from_bamboo_xml(element)
          projects_hash[project.name] = project unless projects_hash[project.name]
        end

        projects_hash.keys.sort.each do |project_name|
          @projects.push(projects_hash[project_name])
        end
      end
    end

    @projects.each do |project|
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

    if @activity_building > 0
      @status = 'building'
    elsif @status_failure > 0 || @status_exception > 0
      @status = 'sick'
    else
      @status = 'healthy'
    end

    @icon = "#{@status}.ico"

    @chuck_norris_fact = 'Chuck Norris ' + CHUCK_NORRIS_FACTS[rand(CHUCK_NORRIS_FACTS.length)]
    @chuck_norris_fact = @chuck_norris_fact.gsub(/Chuck Norris/, 'Chucky') if @skin == 'nightmare'

    render :layout => nil
  end

  def proxy_xml
      server = DashboardConfig.servers_hash[params[:server_id]]

      url = server[:base_url]
      url = "#{url}/" unless url.match(/\/$/)
      url = url + params[:xml_path]

      xml = get_url(url, server[:user], server[:password])
      render :text => xml, :content_type => 'text/xml'
  end

  def proxy_json
      server = DashboardConfig.servers_hash[params[:server_id]]

      url = server[:base_url]
      url = "#{url}/" unless params[:json_path].match(/^\//)
      url = url + params[:json_path]

      json = get_url(url, server[:user], server[:password])
      render :text => json, :content_type => 'application/json'
  end

  def play_alarm
    sound = params[:sound]
    extension = 'wav'

    if File.exists?("public/audios/alarms/#{sound}.#{extension}")
      alarm_path = "#{sound}.#{extension}"
    elsif Dir.exists?("public/audios/alarms/#{sound}")
      all_alarms = Dir.glob("public/audios/alarms/#{sound}/*.#{extension}")
      rand_alarm = randomish_alarm(all_alarms, sound)
      if sound.blank?
        alarm_path = "#{rand_alarm}"
      else
        alarm_path = "#{sound}/#{rand_alarm}"
      end
    else
      all_alarms = Dir.glob("public/audios/alarms/*.#{extension}")
      alarm_path = randomish_alarm(all_alarms)
    end

    send_file "#{Rails.root}/public/audios/alarms/#{alarm_path}"
  end

  private

  def get_cctray_feed_xml(url, user, password)
    begin
      get_url(url, user, password)
    rescue Exception => e
      cctray_error_xml(url, e.message)
    end    
  end

  def get_url(url, user, password)
    uri = URI.parse(url)

    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth user, password if user && password

    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.open_timeout = DashboardConfig.http_open_timeout
      http.read_timeout = DashboardConfig.http_read_timeout

      response = http.request(request)

      case response
        when Net::HTTPSuccess     then response.body
        when Net::HTTPRedirection then get_url(response['location'], user, password)
        else raise response.message
      end
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

  def randomish_alarm(all_alarms, folder)
    folder = 'default' if folder.blank?

    alarm_seq_hash = session[:alarm_seqs]||{}
    alarm_seq = alarm_seq_hash[folder]||rand(100)

    alarm_index = alarm_seq % all_alarms.size

    alarm_seq = alarm_seq + 1
    alarm_seq = 0 if alarm_seq > 999999

    alarm_seq_hash[folder] = alarm_seq
    session[:alarm_seqs] = alarm_seq_hash

    all_alarms = all_alarms.sort
    File.basename(all_alarms[alarm_index])
  end

  def load_config
    load "#{Rails.root}/config/cc_dashboard_config.rb" if File.exists?("#{Rails.root}/config/cc_dashboard_config.rb")
    DashboardConfig.servers_hash = {}
    DashboardConfig.servers.each do |server|
      DashboardConfig.servers_hash[server[:id]] = server
    end
  end

end
