# encoding: utf-8
module ERails
  module ViewHelper
    def onDev
      Rails.env != 'production'
    end

    def seajs_and_jquery(*args)
      v = args.extract_options!
      paths = {
        :seajs => "seajs/#{v[:seajs] || JS_VERSION[:seajs]}/sea.js",
        :jquery => "jquery/#{v[:jquery] || JS_VERSION[:jquery]}/jquery.js",
        :seajs_config => "seajs-config.js"
      }
      id = 'seajsnode'

      if onDev
        paths.map{ |k, v| paths[k] = 'modules/' + v }
        return javascript_include_tag(paths[:seajs], :id => id) + javascript_include_tag(paths[:seajs_config], paths[:jquery])
      else
        path = File.join(APP_CONFIG['js_host'], 'modules', "??#{paths[:seajs]},#{paths[:jquery]}")
        ts = '?' + RELEASE_VERSION + '.js'
        return javascript_include_tag path + ts, :id => id, :type => nil
      end
    end

    def seajs_use(*args)
      content_tag "script", "seajs.use(#{local2web *args})", {}, false
    end

    def local2web(*args)
      args.map do |arg|
        next arg if arg.start_with?('/assets/', '#')
        next File.join('/assets', APP_CONFIG['assets_dir'], 'src', arg) if onDev
        File.join(APP_CONFIG['js_host'], APP_CONFIG['assets_dir'], RELEASE_VERSION, arg)
      end.inspect
    end
  end
end
