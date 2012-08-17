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

## Step 4

#### 提交SVN时，勿忘 Ignore 项目根目录下的 *log* 和 *tmp* !!



# Helper
***

## seajs_and_jquery

默认从 `seajs-config.js` 自动获取版本号，也可手动配置。

```ruby
== seajs_and_jquery
== seajs_and_jquery :seajs => '1.2.1', :jquery => '1.8.0'
```

## seajs_use(*args)

在页面生成 JS 代码。`{{ assets_dir }}` 在 `config.yml` 中配置。

```ruby
== seajs_use 'index'
# <script>seajs.use(['/assets/{{ assets_dir }}/src/index'])</script>

== seajs_use 'index', '#jquery/1.7.2/jquery'
# <script>seajs.use(['/assets/{{ assets_dir }}/src/index', '#jquery/1.7.2/jquery'])</script>
```

## local2web(*args)

转换 `development` 和 `production` 不同环境下 JS 路径。需要给 `seajs.use` 传入 callback 时使用。

```ruby
javascript:
  seajs.use(#{{ local2web 'index', '#jquery/1.7.2/jquery' }}, function(i, $) {
    $(function() {
      ...
    })
  })
```

## date_time(time)

把计算机时间格式化为自然语言，可传入字符串。输出：2012年12月21日、昨天、3分钟前...

## geturl(*args)

处理当前页 URI 的参数并返回新的 URI

#### `date_time` 和 `geturl` 可同时在 Controller 中使用



# path
***

当传入 `/assets/` 开头的绝对路径时，原值输出，否则自动添加 `{{ assets_dir }}`。

## SCSS 中：path(source, only_path=false)

```css
background-image: path('ninja.png')
/* background-image: url(/assets/{{ assets_dir }}/ninja.png) */

background-image: path('/assets/ninja.png')
/* background-image: url(/assets/ninja.png) */
```

## View 中：String.path

```ruby
= stylesheet_link_tag "ninja".path
# <link href="/assets/{{ assets_dir }}/ninja.css" rel="stylesheet" />

= image_tag "/assets/ninja.png".path
# <img src="/assets/ninja.png" />
```
