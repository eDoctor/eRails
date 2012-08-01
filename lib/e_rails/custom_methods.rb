module ERails
  module CustomMethods
    ## 处理当前页URL的参数并返回新的URL ##
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
