root = Rails.root.to_s
env = Rails.env

RELEASE_VERSION = File.basename(root)

APP_CONFIG = if File.file?(config_yml = File.join(root, "config/config.yml"))
  YAML.load_file(config_yml)[env]
else
  {}
end

paths = env.development? ? "app/assets/javascripts/#{APP_CONFIG["assets_dir"]}" : "tmp"
JS_VERSION = if File.file?(package_json = File.join(root, paths, "package.json"))
  JSON(File.read(package_json))["devDependencies"]
else
  {}
end
