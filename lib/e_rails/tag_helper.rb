# encoding: utf-8
module ActionView; module Helpers; module TagHelper

  INPUT_TYPES = %w( text password search email tel url )

  # Overwrite https://github.com/rails/rails/blob/master/actionview/lib/action_view/helpers/tag_helper.rb#L67-L69
  def tag(name, options = nil, open = false, escape = true)
    if name.to_s == "input" && INPUT_TYPES.include?(options["type"])
      options["class"] = "input" unless options.key?("class")
      options["placeholder"] = multi_capitalize(options["name"]) unless options.key?("placeholder")
      options.except! "size"
    end

    "<#{name}#{tag_options(options, escape) if options}#{open ? ">" : " />"}".html_safe
  end

  private
    def multi_capitalize(value)
      sanitize_to_id(value).split("_").map { |val| val.capitalize }.join(" ")
    end

end; end; end
