# encoding: utf-8
module ActionView; module Helpers

  class InstanceTag
    DEFAULT_FIELD_OPTIONS.except! "size"
    DEFAULT_TEXT_AREA_OPTIONS.except! "cols", "rows"
  end

  module TagHelper

    INPUT_TYPES = %w( text password search email tel url )

    # Overwrite https://github.com/rails/rails/blob/v3.2.14/actionpack/lib/action_view/helpers/tag_helper.rb#L65-L67
    def tag(name, options = nil, open = false, escape = true)
      # merge default className and placeholder
      options = merge_options(options) if name.to_s == "input" && INPUT_TYPES.include?(options["type"])

      "<#{name}#{tag_options(options, escape) if options}#{open ? ">" : " />"}".html_safe
    end

    # Overwrite https://github.com/rails/rails/blob/v3.2.14/actionpack/lib/action_view/helpers/tag_helper.rb#L92-L99
    def content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
      if block_given?
        options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
        content_tag_string(name, capture(&block), options, escape)
      else
        # Merge default className and placeholder
        options = merge_options(options) if name.to_s == "textarea"

        content_tag_string(name, content_or_options_with_block, options, escape)
      end
    end

    private

      def multi_capitalize(value)
        sanitize_to_id(value).split("_").map { |val| val.capitalize }.join(" ")
      end

      def merge_options(options)
        options ||= {}
        options.stringify_keys!
        options.reverse_merge! "placeholder" => multi_capitalize(options["name"])
        options.merge "class" => ([] << "input" << options["class"]).flatten.compact.uniq
      end

  end

end; end
