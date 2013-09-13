module ERails
  class Engine < ::Rails::Engine
    initializer 'e_rails' do
      require 'e_rails/extends'

      ActiveSupport.on_load(:action_view) do
        require 'e_rails/tag_helper'
        require 'e_rails/form_tag_helper'
        require 'e_rails/view_helper'
        ActionView::Base.send :include, ERails::ViewHelper
      end

      ActiveSupport.on_load(:action_controller) do
        require 'e_rails/custom_methods'
        ActionController::Base.send :include, ERails::CustomMethods
      end
    end
  end
end
