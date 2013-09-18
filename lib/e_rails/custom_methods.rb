# encoding: utf-8
require 'active_support/concern'
module ERails
  module CustomMethods
    extend ActiveSupport::Concern

    included do
      helper_method :date_time, :geturl, :to_compact_a
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
      operators = args.extract_options!.stringify_keys
      params = request.GET.dup

      # 保留项，其余移除
      unless (keep_params = operators['keep_params']).blank?
        params.slice! *to_compact_a(keep_params)
      end

      # 移除项，其余保留
      unless (remove_params = operators['remove_params']).nil?
        remove_params = to_compact_a(remove_params)

        # 是空数组则移除全部
        if remove_params.blank?
          params.clear
        else
          params.except! *remove_params
        end
      end

      # 新增或替换
      unless (edit_params = operators['edit_params']).blank?
        params.merge! edit_params.stringify_keys
      end

      path = args[0] || request.path
      return path if params.blank?

      no_value_params = params.select{ |k, v| v.nil? }.keys
      return path + '?' + params.to_query if no_value_params.blank?

      params.except! *no_value_params
      path + '?' + to_compact_a(params.to_query, no_value_params) * '&'
    end

    # 把不同类型的元素去空、去重后组成一个一维数组
    def to_compact_a(*args)
      args.flatten.select { |arg| !arg.blank? }.collect(&:to_s).uniq
    end

  end
end
