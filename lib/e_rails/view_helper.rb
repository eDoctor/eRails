# encoding: utf-8
module ERails
  module ViewHelper
    # 格式化日期时间
    def date_time(time)
      time = time.localtime
      norm = DateTime.now
      format = "%Y年%m月%d日 %H:%M"
      arr = ["今天", "明天", "后天", "前天", "昨天"]
      s = (time - norm).to_i.seconds.abs # 秒数差
      d = (time.to_date - norm.to_date).to_i # 天数差

      if s <= 1.minute
        return "刚刚" if time < norm
        return (s < 1 ? 1 : s).to_s << "秒后"
      elsif s <= 1.hour
        return (s/60).to_i.to_s << "分钟" << (time < norm ? "前" : "后")
      elsif d.abs <= 2
        return arr[d] << time.strftime(" %H:%M")
      elsif time.year == norm.year
        return time.strftime(format[5..-1])
      else
        return time.strftime(format)
      end
    rescue
      nil
    end


    def onDev
      Rails.env == "development"
    end


    # 获取 release 版本号
    def release_version
      @release_version ||= File.basename(Rails.root.to_s)
    end


    # 切换 development 和 production 两种环境下的 js 引用路径
    def local2web(source)
      return javascript_path source if onDev
      # paths = source.split('/')
      # File.join(APP_CONFIG['js_host'], paths[0], release_version, paths[1..-1])
      File.join(APP_CONFIG['js_host'], source)
    end


    def seajs_path(v="1.2.0")
      path = "lib/seajs/#{v}/sea.js"
      return path if onDev
      File.join(APP_CONFIG['js_host'], path)
    end

    def seajs_include_tag(source)
      javascript_include_tag seajs_path, "data-main" => local2web(source)
    end


    def seajs_and_jquery(*args)
      v = args.extract_options!
      files = [
        "seajs/#{v[:seajs] || "1.2.0"}/sea.js",
        "seajs-alias.js",
        "jquery/#{v[:jquery] || "1.7.2"}/jquery.js"
      ]

      if onDev
        files = files.map { |file| "lib/" + file }
        return javascript_include_tag(files[0], :id => "seajsnode"), javascript_include_tag(files[1], files[2])
      else
        src = File.join(APP_CONFIG['js_host'], "lib", "??#{files.join(',')}")
        ts = "?r=" + release_version
        return javascript_include_tag src + ts, :id => "seajsnode", :type => nil
      end
    end


    def kindeditor_include_tag
      src = onDev ? "lib/editor/ke" : File.join(APP_CONFIG['js_host'], "lib/editor/kindeditor.js")
      javascript_include_tag src, :type => nil
    end


    def more_to(url="#")
      link_to sanitize("更多 &raquo;"), url, :class => "more"
    end
  end
end
