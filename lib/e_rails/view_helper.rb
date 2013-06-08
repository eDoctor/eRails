# encoding: utf-8
module ERails
  module ViewHelper
    def onDev
      Rails.env != "production"
    end

    def seajs_include_tag
      source = "seajs/#{ JS_VERSION["seajs"] }/sea.js"
      source = File.join(APP_CONFIG["js_host"], source + "?" + RELEASE_VERSION)  unless onDev

      configs = {
        "alias" => {
          "$" => "#{ get_jquery_path '$' }",
          "$-2.x" => "#{ get_jquery_path '$-2.x' }"
        },
        "vars" => {
          "locale" => "#{ I18n.locale.to_s }"
        }
      }

      tags = content_tag(:script, "seajs.config(" + configs.to_json + ");", { :type => nil }, false)
      tags = javascript_include_tag("seajs/config", :type => nil) + tags  if onDev

      javascript_include_tag(source, :type => nil, :id => "seajsnode") + tags
    end

    def seajs_use(*sources)
      content_tag :script, "seajs.use(#{ sources.to_cmd });", { :type => nil }, false
    end

    def noncmd_include_tag(*sources)
      sources.map do |source|
        source = File.join("noncmd", source)
        source = File.join(APP_CONFIG["js_host"], source)  unless onDev
        javascript_include_tag(source)
      end.join("").html_safe
    end

    ################################
    def seajs_and_jquery(*sources)
      seajs_include_tag
    end

    def local2web(*sources)
      sources.to_cmd
    end
    ################################

    private
    def get_jquery_path(key)
      "gallery/jquery/#{ JS_VERSION[key] }/jquery"
    end
  end
end
