# Helpers
***

## seajs_include_tag(*plugins)

引入`sea.js`，以及相关配置、插件

```ruby
= seajs_include_tag
= seajs_include_tag :text, :combo
```

## seajs_use(*sources)

加载 CMD 模块

```ruby
= seajs_use 'foo', '#gallery/jquery/1.10.1/jquery'
```

上面的代码会在页面中插入一个`script`标签，如果模块名称前有井号`#`符号，将不会自动添加项目路径前缀，原貌输出：

```
<script>seajs.use(['path/to/foo', 'gallery/jquery/1.10.1/jquery'])</script>
```

如果需要给`seajs.use`传入回调，直接在 Slim 上写 JS，并借助`Array.to_cmd`：

```
javascript:
  seajs.use(#{{ ['foo', '#gallery/jquery/1.10.1/jquery'].to_cmd }}, function(Foo, $) {
    $(function() {
      seajs.log('呵呵')
    })
  })
```

## noncmd_include_tag(*sources)

引入`noncmd/`目录内的普通 js 文件（非 CMD 模块）

比如引入`noncmd/foo.js`和`noncmd/bar.js`：

```ruby
= noncmd_include_tag 'foo', 'bar'
```

---

> 以上 3 个 helper 都会根据`Rails.env`自动调整线上、线下路径

---

## button_tag(*options, &block)

## submit_tag(*options, &block)

```ruby
= button_tag
  # => <button type="button" class="btn">Button</button>

= submit_tag
  # => <button type="submit" class="btn">Submit</button>

= button_tag 'Delete', class: 'btn btn-danger'
  # => <button type="button" class="btn btn-danger">Delete</button>

= button_tag class: nil do
  span click me
  # => <button type="button"><span>click me</span></button>
```

## date_time(from_time, locale = I18n.locale)

把计算机时间格式化为自然语言，可传入字符串。输出：3分钟前、昨天 12:00、just now ...

## geturl(*args)

处理当前页 URI 的参数并返回新的 URI

#### `date_time` 和 `geturl` 可同时在 Controller 中使用
