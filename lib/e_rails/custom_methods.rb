# encoding: utf-8
require 'active_support/concern'
module ERails
  module CustomMethods
    extend ActiveSupport::Concern
    
    included do
      helper_method :date_time, :geturl
    end

    ## 格式化日期时间 ##
    def date_time(time)
      time = Time.parse(time).localtime
      now = DateTime.now
      format = "%Y年%m月%d日 %H:%M"
      arr = ["今天", "明天", "后天", "前天", "昨天"]
      s = (time - now).to_i.seconds.abs # 秒数差
      d = (time.to_date - now.to_date).to_i # 天数差

      if s <= 1.minute
        return "刚刚" if time < now
        return (s < 1 ? 1 : s).to_s << "秒后"
      elsif s <= 1.hour
        return (s/60).to_i.to_s << "分钟" << (time < now ? "前" : "后")
      elsif d.abs <= 2
        return arr[d] << time.strftime(" %H:%M")
      elsif time.year == now.year
        return time.strftime(format[5..-1])
      else
        return time.strftime(format)
      end
    rescue
      nil
    end

    ## 处理当前页 URI 的参数并返回新的 URI ##
    def geturl(*args)
      opts = args.extract_options!
      url, params = request.fullpath.split('?')
      url = args.first unless args.first.blank?

      if params.blank?
        params = {}
      else
        params = params.split("&").collect{|x| x.split("=")}.collect{|x| {x[0].to_s => x[1].to_s}}.inject(:merge)
      end

      # 保留参数(其余移除)
      if !(keep_params = opts[:keep_params]).blank?
        temp_params = {}
        params.each do |k,v|
          temp_params[k] = v if keep_params.index k
        end
        params = temp_params
      end

      # 移除参数
      if (remove_params = opts[:remove_params]).is_a? Array
        if remove_params.empty? # 是空数组则移除全部
          params = {}
        else
          remove_params.each { |i| params.delete i }
        end
      end

      # 替换/新增参数
      opts[:edit_params].each { |k,v| params[k.to_s] = v.to_s } unless opts[:edit_params].blank?

      return url + (params.blank? ? "" : "?" + params.collect{|k,v| k.to_s + "=" + v.to_s}.join("&"))
    end
  end
end
