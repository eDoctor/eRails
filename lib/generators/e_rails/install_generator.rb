module ERails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.expand_path('../../../../templates', __FILE__)
      end

      def init_compass
        run 'bundle exec compass init rails'
      end

      def clean
        run 'rm -r app/assets/images/* app/assets/javascripts/* app/assets/stylesheets/*'
        run 'rm -r .gitignore app/views/layouts/application.html.erb config/database.yml public/index.html'
      end

      def copy_files
        copy_file 'gitignore', '.gitignore'
        copy_file 'config.yml.example', 'config/config.yml.example'
        copy_file 'database.yml.example', 'config/database.yml.example'
        copy_file 'app_config.rb', 'config/initializers/app_config.rb'
        copy_file 'slim.rb', 'config/initializers/slim.rb'
      end

      def modify_environments
        gsub_file 'config/environments/production.rb', /config.assets.compile = false/, 'config.assets.compile = true'
        insert_into_file 'config/environments/production.rb', "\n  config.assets.precompile += [/[^_]\.css$/]", :after => /\( search.js \)/
        insert_into_file 'config/environments/development.rb', "\n  config.sass.line_comments = false\n", :after => /debug = true\n/
      end

      def set_locales_for_date_time_helper
        copy_file 'zh_cn_datetime.yml', 'config/locales/zh_cn_datetime.yml'
        copy_file 'en_datetime.yml', 'config/locales/en_datetime.yml'
        gsub_file 'config/application.rb', /# config.i18n.default_locale = :de/, 'config.i18n.default_locale = :zh_cn'
      end
    end
  end
end
