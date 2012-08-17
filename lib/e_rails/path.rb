module Sass::Script::Functions

  # instead of image-url(), but with the `assets_dir`
  def path(source, only_path = Sass::Script::Bool.new(false))
    source = source.value.path

    source = "url(/assets/#{source})" if !only_path.to_bool

    Sass::Script::String.new(source)
  end

end


class String

  # instead of xxx_path(), but with the `assets_dir`
  def path
    source = self

    if source[0..7] != "/assets/" && source[0..3] != "http"
      source = APP_CONFIG["assets_dir"] + "/" + source
    end

    source
  end

end
