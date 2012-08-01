module ERails
  class Engine < ::Rails::Engine
    initializer 'erail_app' do |app|
      ActiveSupport.on_load(:action_view) do
        require "e_rails/view_helper"
        class ActionView::Base
          include ERails::ViewHelper
        end
      end
    end
  end
end
