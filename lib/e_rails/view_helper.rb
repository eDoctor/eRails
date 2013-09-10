# encoding: utf-8
module ERails
  module ViewHelper

    def onDev
      Rails.env.development?
    end

    def seajs_include_tag(*options)
      configs = options.extract_options!.stringify_keys
      plugins = ([:log] | options).map { |plugin| 'seajs-' + plugin.to_s + '.js' }
      seajs_dir = "seajs/#{ JS_VERSION['seajs'] }/"

      configs.deep_merge!(
        'alias' => {
          '$' => "gallery/jquery/#{ JS_VERSION['jquery'] }/jquery",
          'seajs-debug' => seajs_dir + 'seajs-debug'
        },
        'vars' => {
          'locale' => I18n.locale
        }
      )
      configs.merge! 'map' => configs['map'].to_a | [['.js', '.js?' + Time.now.to_i.to_s]] if onDev

      configs_tag = content_tag :script, 'seajs.config(' + configs.to_json + ')', { type: nil }, false

      if onDev
        plugins = plugins.map { |plugin| seajs_dir + plugin }

        return javascript_include_tag(seajs_dir + 'sea.js', type: nil, id: 'seajsnode') +
               javascript_include_tag(*plugins, type: nil) +
               javascript_include_tag('seajs/config.js', type: nil) +
               configs_tag
      end

      javascript_include_tag(
        js_host() + seajs_dir + '??sea.js,' + plugins.join(',') + '?' + RELEASE_VERSION,
        type: nil,
        id: 'seajsnode'
      ) + configs_tag
    end

    def seajs_use(*sources)
      content_tag :script, "seajs.use(#{ sources.to_cmd })", { type: nil }, false
    end

    def noncmd_include_tag(*sources)
      sources.map do |source|
        source = source + '.js' if File.extname(source).blank?
        source = 'noncmd/' + source
        source = js_host() + source unless onDev
        javascript_include_tag(source, type: nil)
      end.join('').html_safe
    end

    def flash_message(*options)
      flash_tags = ''
      [:success, :error, :warn, :info].each do |type|
        unless flash[type].blank?
          msg_tags = ''
          ([] << flash[type]).flatten.compact.each do |msg|
            msg_tags += content_tag(:p, t(msg, scope: [:flash, type], default: msg))
          end

          flash_tags += content_tag(:div, msg_tags.html_safe, class: "flash-#{type}")
        end
      end

      options = options.extract_options!.stringify_keys
      options.reverse_merge! 'id' => 'j-flash'
      options.merge! 'class' => ([] << 'flash-message' << options['class']).flatten.compact.uniq

      content_tag :div, flash_tags.html_safe, options
    end

    private

      def js_host
        request.protocol + 'edrjs.com/'
      end

  end
end
