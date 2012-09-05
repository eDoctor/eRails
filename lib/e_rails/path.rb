module Sass::Script::Functions

  # instead of image-url(), but with the `assets_dir` prefix
  def path(source, only_path = Sass::Script::Bool.new(false))
    source = source.value.path

    unless only_path.to_bool
      source = File.join('/assets', source) unless source.start_with?('/assets/', 'http')
      source = "url(#{source})"
    end

    Sass::Script::String.new(source)
  end

end


class String

  #         'xxx'.path => `assets_dir` + xxx
  # '/assets/xxx'.path => /assets/xxx
  def path
    source = self
    source = File.join(APP_CONFIG['assets_dir'], source) unless source.start_with?('/assets/', 'http')
    source
  end

end
