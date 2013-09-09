# encoding: utf-8
module ActionView; module Helpers; module FormTagHelper

  # 减少参数个数
  def text_field_tag(*args)
    tag :input, args.extract_options!.stringify_keys.reverse_merge(
      "name" => args.first,
      "id" => sanitize_to_id(args.first),
      "value" => args.second,
      "type" => "text"
    )
  end

  # 扩展类型 http://www.w3schools.com/tags/att_input_type.asp
  %w( hidden file password email url tel search color date time datetime datetime-local month week number range ).each do |type|
    class_eval <<-RUBY_EVAL
      def #{type.underscore}_field_tag(*args)
        options = args.extract_options!.stringify_keys.merge "type" => "#{type}"
        if range = options.delete("in")
          options.merge! "min" => range.min, "max" => range.max
        end
        text_field_tag(*args << options)
      end
    RUBY_EVAL
  end
  alias_method :telephone_field_tag, :tel_field_tag
  alias_method :phone_field_tag, :tel_field_tag


  %w( button submit reset ).each do |type|
    class_eval <<-RUBY_EVAL
      def #{type}_tag(*args, &block)
        options = args.extract_options!.stringify_keys.merge(
          "type" => "#{type}",
          "placeholder" => nil
        )
        options = merge_defaults(options, "btn")

        return content_tag :button, options, &block if block_given?

        val = args.empty? ? "#{type}" : args.first
        content_tag :button, t(val, scope: [:button_tag], default: val.capitalize), options
      end
    RUBY_EVAL
  end

end; end; end
