$:.push File.expand_path("../lib", __FILE__)

require "e_rails/version"

Gem::Specification.new do |s|
  s.name     = "e_rails"
  s.version  = ERails::VERSION
  s.files    = Dir["{lib,templates}/**/*"] + %w{README.md}
  s.homepage = "https://github.com/eDoctor/eRails"
  s.authors  = ["mrichie"]
  s.summary  = "after: rails new"

  s.add_dependency "rails", "~> 3.2.6"
end
