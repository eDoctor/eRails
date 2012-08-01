# 新建 Rails3.2+ 项目步骤
***

## Step 1

```ruby
rails new [project_name] -d=mysql -T --skip-bundle
cd [project_name]
```

## Step 2

```ruby
echo "source 'http://ruby.taobao.org'" > Gemfile
echo "gem 'rails', '~> 3.2.6'" >> Gemfile
echo "gem 'e_rails', :git => 'git://github.com/eDoctor/eRails.git'" >> Gemfile
```

## Step 3

```ruby
rails g e_rails:install
```

## Step 4

#### 提交SVN时，勿忘Ignore根目录下的 *log* 和 *tmp* !!
