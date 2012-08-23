module Sass::Script::Functions

  # instead of image-url(), but with the `assets_dir`
  def path(source, only_path = Sass::Script::Bool.new(false))
    source = source.value.path
    source = "url(/assets/#{source})" unless only_path.to_bool
    Sass::Script::String.new(source)
  end

end


class String

  # instead of xxx_path(), but with the `assets_dir`
  def path
    source = self
    source = File.join(APP_CONFIG['assets_dir'], source) unless source.start_with?('/assets/', 'http')
    source
  end

end
