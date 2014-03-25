# NOTE: this is simple facade for PlatformSettings model

class Settings
  def self.method_missing(attribute)
    @platform_settings ||= PlatformSettings.last

    @platform_settings.send(attribute)
  end
end
