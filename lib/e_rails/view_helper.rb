# encoding: utf-8
module ERails
  module ViewHelper
    def onDev
      Rails.env != "production"
    end

    def seajs_include_tag
      seajs_dir = "seajs/#{ JS_VERSION["seajs"] }/"

      configs = {
        "alias" => {
          "$" => "gallery/jquery/#{ JS_VERSION["jquery"] }/jquery",
          "seajs-debug" => seajs_dir + "seajs-debug"
        },
        "vars" => {
          "locale" => I18n.locale
        }
      }

      nocache = !onDev ? "" :
        ";seajs.on('fetch',function(data){" +
          "data.requestUri = data.uri + '?' + new Date().getTime()" +
        "})"

      scripts = content_tag :script, "seajs.config(" + configs.to_json + ")" + nocache, { :type => nil }, false

      return javascript_include_tag(seajs_dir + "sea", :type => nil, :id => "seajsnode") +
             javascript_include_tag(seajs_dir + "seajs-log", :type => nil) +
             javascript_include_tag("seajs/config", :type => nil) +
             scripts  if onDev

      javascript_include_tag(
        File.join(APP_CONFIG["js_host"], seajs_dir) + "??sea.js,seajs-log.js?" + RELEASE_VERSION,
        :type => nil,
        :id => "seajsnode"
      ) + scripts
    end

    def seajs_use(*sources)
      content_tag :script, "seajs.use(#{ sources.to_cmd })", { :type => nil }, false
    end

    def noncmd_include_tag(*sources)
      sources.map do |source|
        source = "noncmd/" + source
        source = File.join(APP_CONFIG["js_host"], source)  unless onDev
        javascript_include_tag(source)
      end.join("").html_safe
    end
  end
end
