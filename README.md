# 新建 Rails3.2+ 项目步骤
***

## Step 1

```ruby
rails new app_name -d=mysql -T --skip-bundle
cd app_name/
```

## Step 2

使用下面的代码替换掉默认的 `Gemfile` 内容

```ruby
source 'http://ruby.taobao.org'

gem 'rails', '~> 3.2.8'
gem 'e_rails', :git => 'git://github.com/eDoctor/eRails.git'
gem 'slim-rails'

group :assets do
  gem 'compass-rails'
  gem 'sass-rails'
end

########## ☟ Sort by letter ☟ ##########
# gem 'capistrano'
# gem 'mongoid'
# gem 'mysql2'
# gem 'rails_emoji'
# gem 'rails_kindeditor'
```

## Step 3

```ruby
bundle install
rails g e_rails:install
```
