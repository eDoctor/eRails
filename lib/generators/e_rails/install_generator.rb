module ERails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.expand_path('../../../../templates', __FILE__)
      end

      def copy_config_file
        copy_file 'Gemfile', 'Gemfile'
        copy_file 'gitignore', '.gitignore'
        
        copy_file 'app_config.rb', 'config/initializers/app_config.rb'
        copy_file 'slim.rb', 'config/initializers/slim.rb'
        
        copy_file 'config.yml.example', 'config/config.yml.example'
        copy_file 'database.yml.example', 'config/database.yml.example'
        
        gsub_file 'config/environments/production.rb', /config.assets.compile = false/, 'config.assets.compile = true'
        gsub_file 'config/environments/production.rb', /# config.assets.precompile += %w( search.js )/, 'config.assets.precompile = [/[^_]\.css$/]'
       
        insert_into_file 'config/environments/development.rb', "  config.sass.line_comments = false\n\n", :after => /configure do\n/

        run 'bundle install && bundle exec compass init rails'
        run 'rm -r app/assets/images/*'
        run 'rm -r app/assets/javascripts/*'
        run 'rm -r app/assets/stylesheets/*'
        run 'rm -r config/database.yml'
        run 'rm -r public/index.html'
      end
    end
  end
end
