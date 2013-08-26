# encoding: utf-8
module ERails
  module ViewHelper
    def onDev
      Rails.env != "production"
    end

    def seajs_include_tag(*options)
      configs = options.extract_options!.stringify_keys
      plugins = ([:log] | options).map { |plugin| "seajs-" + plugin.to_s + ".js" }
      seajs_dir = "seajs/#{ JS_VERSION["seajs"] }/"

      configs.deep_merge!(
        "alias" => {
          "$" => "gallery/jquery/#{ JS_VERSION["jquery"] }/jquery",
          "seajs-debug" => seajs_dir + "seajs-debug"
        },
        "vars" => {
          "locale" => I18n.locale
        }
      )
      configs.merge! "map" => configs["map"].to_a | [[".js", ".js?" + Time.now.to_i.to_s]] if onDev

      configs_tag = content_tag :script, "seajs.config(" + configs.to_json + ")", { type: nil }, false

      if onDev
        plugins = plugins.map { |plugin| seajs_dir + plugin }

        return javascript_include_tag(seajs_dir + "sea.js", type: nil, id: "seajsnode") +
               javascript_include_tag(*plugins, type: nil) +
               javascript_include_tag("seajs/config.js", type: nil) +
               configs_tag
      end

      javascript_include_tag(
        _js_host() + seajs_dir + "??sea.js," + plugins.join(",") + "?" + RELEASE_VERSION,
        type: nil,
        id: "seajsnode"
      ) + configs_tag
    end

    def seajs_use(*sources)
      content_tag :script, "seajs.use(#{ sources.to_cmd })", { type: nil }, false
    end

    def noncmd_include_tag(*sources)
      sources.map do |source|
        source = source + ".js" if File.extname(source).blank?
        source = "noncmd/" + source
        source = _js_host() + source unless onDev
        javascript_include_tag(source, type: nil)
      end.join("").html_safe
    end

    # Overwrite helpers in Rails
    def button_tag(*options, &block)
      _button_tag "button", *options, &block
    end

    def submit_tag(*options, &block)
      _button_tag "submit", *options, &block
    end

    def text_field_tag(name, *options)
      opts = options.extract_options!.stringify_keys.reverse_merge(
        "type" => "text",
        "name" => name,
        "id" => sanitize_to_id(name),
        "value" => options.first,
        "class" => "input",
        "placeholder" => _capitalize(name)
      )
      tag :input, opts
    end

    def hidden_field_tag(name, *options)
      _x_field_tag name, "hidden", *options
    end

    def file_field_tag(name, *options)
      _x_field_tag name, "file", *options
    end


    private
    def _js_host
      request.protocol + "edrjs.com/"
    end

    def _button_tag(type, *options, &block)
      opts = options.extract_options!.stringify_keys
      opts.reverse_merge! "class" => "btn"
      opts.merge! "type" => type

      return content_tag :button, opts, &block if block_given?
      content_tag :button, options.first || t("button_tag." + type), opts
    end

    def _x_field_tag(name, type, *options)
      opts = options.extract_options!.stringify_keys.reverse_merge(
        "class" => nil,
        "placeholder" => nil
      )
      text_field_tag name, options.first, opts.merge("type" => type)
    end

    def _capitalize(value)
      sanitize_to_id(value).split("_").map { |val| val.capitalize }.join(" ")
    end
  end
end
