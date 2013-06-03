# encoding: utf-8
module ERails
  module ViewHelper
    def onDev
      Rails.env != "production"
    end

    def seajs_include_tag(version = JS_VERSION["seajs"])
      source = "seajs/#{ version }/sea"
      configs = ""

      if onDev
        jquery_aliases =
          "seajs.config({" +
            "alias:{" +
              "'$':'#{ get_jquery_path "$" }'," +
              "'$-2.x':'#{ get_jquery_path "$-2.x" }'" +
            "}" +
          "})"

        configs =
          javascript_include_tag("seajs/config", :type => nil) +
          content_tag(:script, jquery_aliases, { :type => nil }, false)
      else
        source =
          APP_CONFIG["js_host"] + "/??" +
          ["~" + source, "seajs-config"].to_cmd.map{ |file| file + '.js' }.join(',')
      end

      javascript_include_tag(source, :type => nil, :id => "seajsnode") + configs
    end

    def seajs_use(*sources)
      content_tag :script, "seajs.use(#{ sources.to_cmd })", { :type => nil }, false
    end

    def noncmd_include_tag(*sources)
      sources.map do |source|
        source = File.join("noncmd", File.basename(source, ".js") + ".js")
        source = File.join(APP_CONFIG["js_host"], source) unless onDev
        javascript_include_tag(source)
      end.join('')
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
