module ERails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.expand_path('../../../../templates', __FILE__)
      end

      def copy_config_file
        copy_file 'Gemfile', 'Gemfile'
        
        copy_file 'config/app_config.rb', 'config/initializers/app_config.rb'
        copy_file 'config/slim.rb', 'config/initializers/slim.rb'
        
        copy_file 'config/config.yml.example', 'config/config.yml.example'
        copy_file 'config/config.yml.example', 'config/config.yml'
        copy_file 'config/database.yml.example', 'config/database.yml.example'
        copy_file 'config/database.yml.example', 'config/database.yml'
        
        gsub_file 'config/environments/production.rb', /config.assets.compile = false/, 'config/assets.compile = true'
       
        insert_into_file 'config/environments/production.rb', "  config.sass.line_comments = false\n", :after => /configure do\n/
        insert_into_file 'config/environments/production.rb', "  config.assets.precompile = [/[^_]\.css$/]\n", :after => /configure do\n/

        run 'bundle install'
      end
    end
  end
end
