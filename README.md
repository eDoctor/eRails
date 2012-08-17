# 新建 Rails3.2+ 项目步骤
***

## Step 1

```ruby
rails new app_name -d=mysql -T --skip-bundle
cd app_name/
```

## Step 2

```ruby
echo "source 'http://ruby.taobao.org'" > Gemfile
echo "gem 'rails', '~> 3.2.6'" >> Gemfile
echo "gem 'e_rails', :git => 'git://github.com/eDoctor/eRails.git'" >> Gemfile
```

## Step 3

```ruby
bundle install
rails g e_rails:install
```
