# Helpers
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
