# encoding: utf-8
module ActionView; module Helpers; module FormTagHelper

  %w( text password search email tel url hidden ).each do |type|
    class_eval <<-RUBY_EVAL
      def #{type}_field_tag(*sources)
        options = sources.extract_options!.stringify_keys.reverse_merge(
          "name" => sources.first,
          "id" => sanitize_to_id(sources.first),
          "value" => sources.second,
        )
        tag :input, options.merge("type" => "#{type}")
      end
    RUBY_EVAL
  end
  alias_method :telephone_field_tag, :tel_field_tag

  %w( button submit ).each do |type|
    class_eval <<-RUBY_EVAL
      def #{type}_tag(*sources, &block)
        options = sources.extract_options!.stringify_keys
        options.reverse_merge! "class" => "btn"
        options.merge! "type" => "#{type}"

        return content_tag :button, options, &block if block_given?
        content_tag :button, sources.first || t("button_tag.#{type}"), options
      end
    RUBY_EVAL
  end

end; end; end
