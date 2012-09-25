module ERails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.expand_path('../../../../templates', __FILE__)
      end

      def do_something
        copy_file 'gitignore', '.gitignore'
        copy_file 'config.yml.example', 'config/config.yml.example'
        copy_file 'database.yml.example', 'config/database.yml.example'
        copy_file 'app_config.rb', 'config/initializers/app_config.rb'
        copy_file 'slim.rb', 'config/initializers/slim.rb'

        copy_file 'zh_cn_datetime.yml', 'config/locales/zh_cn_datetime.yml'
        copy_file 'en_datetime.yml', 'config/locales/en_datetime.yml'
        gsub_file 'config/application.rb', /# config.i18n.default_locale = :de/, 'config.i18n.default_locale = :zh_cn'

        gsub_file 'config/environments/production.rb', /config.assets.compile = false/, 'config.assets.compile = true'
        insert_into_file 'config/environments/production.rb', "\n  config.assets.precompile += [/[^_]\.css$/]\n", :after => /\( search.js \)\n/
        insert_into_file 'config/environments/development.rb', "\n  config.sass.line_comments = false\n", :after => /debug = true\n/

        run 'bundle exec compass init rails'
        run 'rm -r app/assets/images/*; rm -r app/assets/javascripts/*; rm -r app/assets/stylesheets/*'
        run 'rm -r app/views/layouts/application.html.erb; rm -r config/database.yml; rm -r public/index.html'
      end
    end
  end
end
