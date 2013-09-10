# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require 'e_rails/version'

Gem::Specification.new do |s|
  s.name     = 'e_rails'
  s.version  = ERails::VERSION
  s.files    = Dir['{lib,templates}/**/*'] + %w{README.md Helpers.md Path.md}
  s.homepage = 'https://github.com/eDoctor/eRails'
  s.authors  = ['mrichie <https://github.com/mrichie>', 'wǒ_is神仙 <https://github.com/jsw0528>']
  s.summary  = 'after: rails new'

  s.add_dependency 'rails', '~> 3.2.8'
  s.add_dependency 'sass', '~> 3.2.8'
end
