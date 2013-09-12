# encoding: utf-8
module ActionView; module Helpers

  class InstanceTag
    DEFAULT_FIELD_OPTIONS.except! 'size'
    DEFAULT_TEXT_AREA_OPTIONS.except! 'cols', 'rows'
  end

  module TagHelper

    # Overwrite https://github.com/rails/rails/blob/v3.2.14/actionpack/lib/action_view/helpers/tag_helper.rb#L65-L67
    def tag(name, options = nil, open = false, escape = true)
      if name.to_s == 'input' &&
        !%w( hidden file range checkbox radio ).include?((options || {}).stringify_keys['type'].to_s)
          options = merge_defaults(options)
      end

      "<#{name}#{tag_options(options, escape) if options}#{open ? '>' : ' />'}".html_safe
    end

    # Overwrite https://github.com/rails/rails/blob/v3.2.14/actionpack/lib/action_view/helpers/tag_helper.rb#L92-L99
    def content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
      if block_given?
        options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
        content_tag_string(name, capture(&block), options, escape)
      else
        options = merge_defaults(options) if name.to_s == 'textarea'
        content_tag_string(name, content_or_options_with_block, options, escape)
      end
    end

    private

      # user_name  => User Name
      # user[name] => User Name
      def multi_capitalize(value)
        sanitize_to_id(value).split('_').map { |val| val.capitalize }.join(' ')
      end

      # Add className and placeholder by default
      def merge_defaults(options, className = 'input')
        options = (options || {}).stringify_keys
        options.reverse_merge! 'placeholder' => multi_capitalize(options['name'])

        return options.except 'class' if options.fetch('class', true).blank?

        unless (klass = options['class']).is_a? Array
          klass = klass.to_s.split(' ')
        end

        options.merge 'class' => to_compact_a(className, klass)
      end

      # Remove blank and repeated items
      def to_compact_a(*args)
        args.flatten.select { |arg| !arg.blank? }.collect(&:to_s).uniq
      end

  end

end; end
