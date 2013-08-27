module ActionView; module Helpers; module FormTagHelper

  %w( text password search email tel url hidden ).each do |type|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
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

end; end; end
