# encoding: utf-8
require 'active_support/concern'
module ERails
  module CustomMethods
    extend ActiveSupport::Concern

    included do
      helper_method :date_time, :geturl, :to_compacted_a
    end

    # 格式化时间为自然语言
    def date_time(from_time, locale = I18n.locale)
      from_time = Time.parse(from_time.to_s).localtime
      to_time = Time.now.localtime
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

    # 处理当前页面的 Query String
    def geturl(*args)
      operators = args.extract_options!
      path, *params = request.fullpath.split '?'
      path = args.first unless args.empty?

      if params.empty?
        params = {}
      else
        # e.g. => /?xy[]=x&xy[]=y&xy&z=zzz=&back=/users?page=1

        # => [["xy[]", "x"], ["xy[]", "y"], ["xy", ""], ["z", "zzz="], ["back", "/users?page=1"]]
        params = params.join('?').split('&').map do |param|
          i = param.index('=')
          next [param, ''] if i.nil?
          [param[0...i], param[i+1..-1]]
        end

        # => [["xy[]", "x"], ["xy[]", "y"]]
        grouped_params = params.select { |param| param[0] =~ /.+\[\]$/ }

        # => {"xy"=>"", "z"=>"zzz=", "back"=>"/users?page=1"}
        params = (params - grouped_params).collect { |param| { param[0] => param[1] } }.inject(:merge)

        # => {"xy"=>["", "x", "y"], "z"=>"zzz=", "back"=>"/users?page=1"}
        grouped_params.each do |param|
          k = param[0][0..-3]
          params[k] = params[k].to_a << param[1]
        end
      end

      # 保留项，其余移除
      unless (keep_params = operators[:keep_params]).blank?
        params.slice! *to_compacted_a(keep_params)
      end

      # 移除项，其余保留
      unless (remove_params = operators[:remove_params]).nil?
        remove_params = to_compacted_a(remove_params)

        # 是空数组则移除全部
        if remove_params.empty?
          params.clear
        else
          params.except! *remove_params
        end
      end

      # 新增或替换
      unless (edit_params = operators[:edit_params]).blank?
        params.merge! edit_params.stringify_keys
      end

      return path if params.blank?
      path + '?' + params.to_query
    end

    def to_compacted_a(*args)
      args.flatten.collect(&:to_s).uniq.select { |x| !x.blank? }
    end

  end
end
