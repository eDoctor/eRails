# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name     = 'e_rails'
  s.version  = '3.1.11'
  s.summary  = 'after: rails new'

  s.authors  = ['mrichie <https://github.com/mrichie>', 'wǒ_is神仙 <https://github.com/jsw0528>']
  s.homepage = 'https://github.com/eDoctor/eRails'

  s.files    = Dir['{lib,templates}/**/*'] + %w{README.md Helpers.md Path.md}

  s.add_dependency 'rails', '~> 3.2.8'
  s.add_dependency 'sass', '~> 3.2.8'
end
