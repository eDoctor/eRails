module ERails
  class Engine < ::Rails::Engine
    initializer 'erails_app' do |app|
      require "e_rails/extends"
      require "e_rails/tag_helper"
      require "e_rails/form_tag_helper"

      ActiveSupport.on_load(:action_view) do
        require "e_rails/view_helper"
        ActionView::Base.send :include, ERails::ViewHelper
      end

      ActiveSupport.on_load(:action_controller) do
        require "e_rails/custom_methods"
        ActionController::Base.send :include, ERails::CustomMethods
      end
    end
  end
end
