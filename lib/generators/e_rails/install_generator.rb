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
        run 'rm .gitignore app/views/layouts/* public/index.html config/locales/en.yml'
      end

      def copy_files
        FileUtils.cp 'gitignore', '.gitignore'
        FileUtils.cp 'layout.slim', 'app/views/layouts/application.slim'
        FileUtils.cp_r %w( initializers/ locales/ config.example.yml ), 'config/'
      end

      def modify_env_files
        gsub_file 'config/environments/production.rb', /config\.assets\.compile = false/, 'config.assets.compile = true'
        gsub_file 'config/environments/production.rb', /# config\.assets\.precompile \+= %w\( search\.js \)/, 'config.assets.precompile += [Proc.new { |path| File.basename(path) =~ /^[^_][a-z0-9-]+\.css$/ }]'
        insert_into_file 'config/environments/development.rb', "\n  config.sass.debug_info = true\n", before: /end/
      end

      def modify_configs
        insert_into_file 'config/application.rb', "    config.assets.paths << \"\#{Rails.root}/app/assets/fonts\"\n", after: /enabled = true\n/
        insert_into_file 'config/application.rb', "    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.yml')]\n", before: /    # config\.i18n\.default_locale/
        gsub_file 'config/application.rb', /# config\.i18n\.default_locale = :de/, 'config.i18n.default_locale = :zh_cn'
      end
    end
  end
end
