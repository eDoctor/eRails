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
        run 'rm -r app/assets/**'
        run 'rm .gitignore app/views/layouts/* config/database.yml public/index.html config/locales/en.yml'
      end

      def copy_files
        copy_file 'gitignore', '.gitignore'
        copy_file 'config.example.yml', 'config/config.example.yml'
        copy_file 'app_config.rb', 'config/initializers/app_config.rb'
        copy_file 'slim.rb', 'config/initializers/slim.rb'
        copy_file 'layout.slim', 'app/views/layouts/application.slim'
        copy_file 'zh_cn_datetime.yml', 'config/locales/zh_cn_datetime.yml'
        copy_file 'en_datetime.yml', 'config/locales/en_datetime.yml'
        copy_file 'zh_cn_button_tag.yml', 'config/locales/zh_cn_button_tag.yml'
        copy_file 'en_button_tag.yml', 'config/locales/en_button_tag.yml'
      end

      def modify_environments
        gsub_file 'config/environments/production.rb', /config\.assets\.compile = false/, 'config.assets.compile = true'
        gsub_file 'config/environments/production.rb', /# config\.assets\.precompile \+= %w\( search\.js \)/, 'config.assets.precompile += [Proc.new { |path| File.basename(path) =~ /^[^_][a-z0-9-]+\.css$/ }]'
        insert_into_file 'config/environments/development.rb', "\n  config.sass.debug_info = true\n", before: /end/
      end

      def add_assets_path
        insert_into_file 'config/application.rb', "    config.assets.paths << \"\#{Rails.root}/app/assets/fonts\"\n", after: /enabled = true\n/
      end

      def set_default_locale
        gsub_file 'config/application.rb', /# config\.i18n\.default_locale = :de/, 'config.i18n.default_locale = :zh_cn'
      end
    end
  end
end
