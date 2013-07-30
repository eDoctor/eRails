root = Rails.root.to_s

APP_CONFIG = YAML.load_file("#{root}/config/config.yml")[Rails.env]
RELEASE_VERSION = File.basename(root)

path = Rails.env == "production" ? "tmp" : "app/assets/javascripts/#{APP_CONFIG["assets_dir"]}"
JS_VERSION = JSON(File.read(File.join(root, path, "package.json")))["devDependencies"]
