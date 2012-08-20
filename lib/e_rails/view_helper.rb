# encoding: utf-8
module ERails
  module ViewHelper
    def onDev
      Rails.env != 'production'
    end

    def seajs_and_jquery(*args)
      v = args.extract_options!
      files = [
        "seajs/#{v[:seajs] || JS_VERSION[:seajs]}/sea.js",
        "seajs-config.js",
        "jquery/#{v[:jquery] || JS_VERSION[:jquery]}/jquery.js"
      ]
      id = 'seajsnode'

      if onDev
        files = files.map { |file| 'modules/' + file }
        return javascript_include_tag(files[0], :id => id) + javascript_include_tag(files[1], files[2])
      else
        path = File.join(APP_CONFIG['js_host'], 'modules', "??#{files.join(',')}")
        # ts = '?' + RELEASE_VERSION + '.js'
        return javascript_include_tag path, :id => id, :type => nil
      end
    end

    def seajs_use(*args)
      content_tag "script", "seajs.use(#{local2web *args})", {}, false
    end

    def local2web(*args)
      args.map do |arg|
        next arg if arg[0..0] == '#' || arg[0..7] == '/assets/'
        next File.join('assets', APP_CONFIG['assets_dir'], 'src', arg) if onDev
        File.join(APP_CONFIG['js_host'], APP_CONFIG['assets_dir'], RELEASE_VERSION, arg)
      end.inspect
    end
  end
end
