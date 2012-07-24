# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def skin_random_image_path(prefix, suffix, extension)
    all_images = Dir.glob("app/assets/images/skins/#{@skin}/#{prefix}_#{suffix}*.#{extension}")
    all_images = Dir.glob("app/assets/images/skins/#{@skin}/#{prefix}*.#{extension}") if all_images.empty?
    all_images = Dir.glob("app/assets/images/skins/#{@skin}/#{suffix}*.#{extension}") if all_images.empty?

    random_image = all_images[rand(all_images.size)]

    if random_image.nil?
      image_path("broken.jpg")
    else
      image_path("skins/#{@skin}/#{File.basename(random_image)}")
    end
  end

  def track_random_sound_path(prefix, extension = 'wav')
    all_sounds   = Dir.glob("public/audios/tracks/#{@track}/#{prefix}*.#{extension}")
    random_sound = all_sounds[rand(all_sounds.size)]

    audio_path("tracks/#{@track}/#{File.basename(random_sound)}")
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
    tag(:link, {:rel => 'SHORTCUT_ICON', :href => image_path(skinned_source)}) +
    tag(:link, {:rel => 'icon', :type => 'image/vnd.microsoft.icon', :href => image_path(skinned_source)})
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
