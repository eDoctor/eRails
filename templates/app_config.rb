root = Rails.root.to_s
env = Rails.env

RELEASE_VERSION = File.basename(root)
APP_CONFIG = {}
JS_VERSION = {}

if File.file?(config_yml = File.join(root, "config/config.yml"))
  APP_CONFIG = YAML.load_file(config_yml)[env]
end

if File.file?(package_json = File.join(root, env == "production" ? "tmp" : "app/assets/javascripts/#{APP_CONFIG["assets_dir"]}", "package.json"))
  JS_VERSION = JSON(File.read(package_json))["devDependencies"]
end
