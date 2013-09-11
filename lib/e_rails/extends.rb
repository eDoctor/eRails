module Sass::Script::Functions
  # instead of image-url(), but with the `assets_dir` prefix
  #
  # background-image: path('ninja.png');
  # => background-image: url(/assets/{{ assets_dir }}/ninja.png);
  def path(source, only_path = Sass::Script::Bool.new(false))
    source = source.value.path
    source = "url(#{'/assets/' unless source.start_with?('/', 'http:', 'https:')}#{source})" unless only_path.to_bool
    Sass::Script::String.new(source)
  end
end

class String
  # 'ninja.png'.path
  # => {{ assets_dir }}/ninja.png

  # '/ninja.png'.path
  # => /ninja.png

  # 'http://example.com/ninja.png'.path
  # => http://example.com/ninja.png

  # 'ninja.png'.path(:exam)
  # => {{ assets_dir }}/plugin-exam/ninja.png
  def path(plugin = nil)
    source = []
    unless self.start_with?('/', 'http:', 'https:')
      source << APP_CONFIG['assets_dir']
      source << "plugin-#{plugin}" unless plugin.blank?
    end
    File.join(*source << self)
  end
end

class Array
  # ['ninja', '#jquery'].to_cmd
  # => ['{{ assets_dir }}/src/ninja', 'jquery']
  def to_cmd
    self.map do |item|
      next item[1..-1] if item.start_with?('#')
      [Rails.env.production? ? RELEASE_VERSION : 'src', item].join('/').path
    end
  end
end
