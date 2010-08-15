# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def skin_random_image_path(prefix, extension)
    all_images = Dir.glob("public/images/skins/#{@skin}/#{prefix}*.#{extension}")
    random_image = all_images[rand(all_images.size)]

    image_path("skins/#{@skin}/#{File.basename(random_image)}")
  end

  # Output the difference between a give time and now in
  # approximate seconds/minutes/hours/days
  def time_ago(time)
    time_diff = Time.now.to_i - time.to_i
    if time_diff < 60
      seconds = time_diff
      "#{seconds} second#{pluralise(seconds)} ago"
    elsif time_diff < 3600
      minutes = (time_diff/60).round
      "#{minutes} minute#{pluralise(minutes)} ago"
    elsif time_diff < 86400
      hours = (time_diff/3600).round
      "#{hours} hour#{pluralise(hours)} ago"
    else
      days = (time_diff/86400).round
      "#{days} day#{pluralise(days)} ago"
    end
  end

  # Generate icon tags in both IE-specific and standards formats
  def skinned_icon_tag(source)
    skinned_source = "skins/#{@skin}/favicon_#{source}"
    "<link rel=\"SHORTCUT ICON\" href=\"#{compute_public_path(skinned_source, 'images')}\"/>\n<link rel=\"icon\" type=\"image/vnd.microsoft.icon\" href=\"#{compute_public_path(skinned_source, 'images')}\"/>"
  end

  private

  def pluralise(number)
    if number > 1
      's'
    else
      ''
    end
  end
  
end
