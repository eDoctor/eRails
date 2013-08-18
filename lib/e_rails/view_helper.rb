# encoding: utf-8
module ERails
  module ViewHelper
    def onDev
      Rails.env != "production"
    end

    def seajs_include_tag(*options)
      options = options.extract_options!

      seajs_dir = "seajs/#{ JS_VERSION["seajs"] }/"

      configs = {
        alias: {
          "$" => "gallery/jquery/#{ JS_VERSION["jquery"] }/jquery",
          "seajs-debug" => seajs_dir + "seajs-debug"
        },
        vars: {
          locale: I18n.locale
        }
      }

      configs = configs.merge({
        map: [
          [".js", ".js?" + Time.now.to_i.to_s]
        ]
      }) if onDev

      plugins = ([:log] | options[:plugins].to_a).map { |plugin| "seajs-" + plugin.to_s + ".js" }

      scripts = content_tag :script, "seajs.config(" + configs.to_json + ")", { type: nil }, false

      if onDev
        plugins = plugins.map { |plugin| seajs_dir + plugin }

        return javascript_include_tag(seajs_dir + "sea.js", type: nil, id: "seajsnode") +
               javascript_include_tag(*plugins, type: nil) +
               javascript_include_tag("seajs/config.js", type: nil) +
               scripts
      end

      javascript_include_tag(
        js_host() + seajs_dir + "??sea.js," + plugins.join(",") + "?" + RELEASE_VERSION,
        type: nil,
        id: "seajsnode"
      ) + scripts
    end

    def seajs_use(*sources)
      content_tag :script, "seajs.use(#{ sources.to_cmd })", { type: nil }, false
    end

    def noncmd_include_tag(*sources)
      sources.map do |source|
        source = source + ".js" if File.extname(source).blank?
        source = "noncmd/" + source
        source = js_host() + source unless onDev
        javascript_include_tag(source, type: nil)
      end.join("").html_safe
    end

    # Overwrite helpers in Rails
    def button_tag(*options, &block)
      _button_tag 'button', *options, &block
    end

    def submit_tag(*options, &block)
      _button_tag 'submit', *options, &block
    end

    private
    def js_host
      request.protocol + "edrjs.com/"
    end

    def _button_tag(type, *options, &block)
      opts = options.extract_options!
      opts.reverse_merge! class: 'btn'
      opts.merge! type: type

      return content_tag :button, opts, &block if block_given?
      content_tag :button, options.first || t('button_tag.' + type), opts
    end
  end
end
