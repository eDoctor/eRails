# encoding: utf-8
require 'active_support/concern'
module ERails
  module CustomMethods
    extend ActiveSupport::Concern

    included do
      helper_method :date_time, :geturl
    end

    # 格式化时间为自然语言
    def date_time(from_time, locale = I18n.locale)
      from_time = Time.parse(from_time.to_s).localtime
      to_time   = Time.now.localtime
      distance_in_seconds = (to_time - from_time).to_i

      I18n.with_options locale: locale, scope: :'datetime.distance_in_words' do |locale|
        case distance_in_seconds
        when 0..5 then locale.t :just_now
        when 6..59 then locale.t :x_seconds_ago, count: distance_in_seconds
        # 1分钟 ～ 59分钟59秒
        when 60..3599 then locale.t :x_minutes_ago, count: (distance_in_seconds/60).round
        # >= 1小时
        else
          distance_in_days = (to_time.to_date - from_time.to_date).to_i
          case distance_in_days
          when 0 then locale.t :today_moment, time: from_time.strftime('%H:%M')
          when 1 then locale.t :yesterday_moment, time: from_time.strftime('%H:%M')
          else
            if from_time.year == to_time.year
              from_time.strftime(locale.t('formats.short'))
            else
              from_time.strftime(locale.t('formats.long'))
            end
          end
        end
      end
    end

    # 处理当前页 URI 的参数并返回新的 URI
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

      return [url, params.collect{|k,v| k.to_s + "=" + v.to_s}.join("&")].join('?')
    end
  end
end
