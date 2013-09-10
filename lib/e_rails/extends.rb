module Sass::Script::Functions
  # instead of image-url(), but with the `assets_dir` prefix
  def path(source, only_path = Sass::Script::Bool.new(false))
    source = source.value.path
    source = "url(#{'/assets/' unless source.start_with?('/', 'http:', 'https:')}#{source})" unless only_path.to_bool
    Sass::Script::String.new(source)
  end
end

class String
  #          'foo'.path => `assets_dir` + foo
  # '/path/to/foo'.path => /path/to/foo
  def path
    source = self
    source = File.join(APP_CONFIG['assets_dir'], source) unless source.start_with?('/', 'http:', 'https:')
    source
  end
end

class Array
  def to_cmd
    self.map do |item|
      next item[1..-1] if item.start_with?('#')
      File.join(APP_CONFIG['assets_dir'], Rails.env.production? ? RELEASE_VERSION : 'src', item)
    end
  end
end
