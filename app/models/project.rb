class Project

  attr_accessor :group_name, :server
  attr_reader :name, :nextBuildTime, :webUrl, :activity, :lastBuildStatus, :category, :lastBuildLabel, :lastBuildTime, :culprits
  
  def populate_from_xml(element)
    @name = element.attributes['name']
    @nextBuildTime = element.attributes['nextBuildTime']
    @webUrl = element.attributes['webUrl']
    @activity = element.attributes['activity']
    @lastBuildStatus = element.attributes['lastBuildStatus']
    @category = element.attributes['category']
    @lastBuildLabel = element.attributes['lastBuildLabel']
    @lastBuildTime = Time.parse(element.attributes['lastBuildTime']) rescue element.attributes['lastBuildTime']
  end

  def populate_from_bamboo_xml(element)
    title = element.elements['title'].text
    if title =~ /(.*)-(.*)\s+was\s+SUCCESSFUL\s+/
      @name = $1
      @lastBuildLabel = $2
      @lastBuildStatus = 'Success'
    elsif title =~ /(.*)-(.*)\s+has\s+FAILED\s+/
      @name = $1
      @lastBuildLabel = $2
      @lastBuildStatus = 'Failure'
      @culprits = $3 if title =~ /(.*)-(.*)\s+has\s+FAILED\s+.*\s+Updated\s+by\s+(.*)/
    else
      @name = title
      @lastBuildLabel = 'Unknown'
      @lastBuildStatus = 'Unknown'
    end

    url = element.elements['link'].text
    @webUrl = $1 if url =~ /(.*)-/

    @activity = 'Sleeping' #element.attributes['activity']
    @lastBuildTime = Time.parse(element.elements['pubDate'].text)
  end

end