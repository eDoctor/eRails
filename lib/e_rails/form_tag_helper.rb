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
        options.merge!(
          "type" => "#{type}",
          "class" => ([] << "btn" << options["class"]).flatten.compact.uniq
        )

        return content_tag :button, options, &block if block_given?

        val = sources.empty? ? "#{type}" : sources.first
        content_tag :button, t(val, scope: [:button_tag], default: val), options
      end
    RUBY_EVAL
  end

end; end; end
