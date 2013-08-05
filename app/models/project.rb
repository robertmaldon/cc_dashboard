class Project

  attr_accessor :group_name, :server
  attr_reader :name, :nextBuildTime, :webUrl, :activity, :lastBuildStatus, :category, :lastBuildLabel, :lastBuildTime
  
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

end