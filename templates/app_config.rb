root = Rails.root.to_s

APP_CONFIG = YAML.load_file("#{root}/config/config.yml")[Rails.env]
RELEASE_VERSION = File.basename(root)

# for seajs_and_jquery helper
fileName = 'seajs-config.js'
p1 = root + '/app/assets/javascripts/modules/' + fileName
p2 = root + '/tmp/' + fileName
js_content = ''
v = {}

if File.exist?(p1)
  js_content = File.read(p1)
elsif File.exist?(p2)
  js_content = File.read(p2)
end

js_content.gsub(/\/\/ v([\d\.]+).*'\$': 'jquery\/([\d\.]+)\//m) do
  v[:seajs] = $1
  v[:jquery] = $2
end

JS_VERSION = v
