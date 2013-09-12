# Helpers

## seajs_include_tag(*plugins, config = {})

引入`sea.js`，以及相关[配置](https://github.com/seajs/seajs/issues/262)、[插件](https://github.com/seajs)。

```ruby
# 使用默认插件和配置
= seajs_include_tag

# 增加`text`和`combo`插件
= seajs_include_tag :text, :combo

# 增加`text`插件，配置`underscore.js`的别名，开启 debug 模式
= seajs_include_tag :text, alias: { _: 'gallery/underscore/1.5.1/underscore' }, debug: true
```

> 默认配置中有`locale`变量，值是取的`I18n.locale`，js 可以通过`seajs.data.vars.locale`获取这个变量的值。

## seajs_use(*sources)

生成用于加载 CMD 模块的 js 代码。

如果参数不是以井号`#`开头，则会由 [Path](https://github.com/eDoctor/eRails/blob/2.x/Path.md) 处理后输出：

```ruby
= seajs_use 'foo', '#gallery/jquery/1.10.2/jquery'
# <script>
# seajs.use(['/assets/{{ assets_dir }}/src/foo', 'gallery/jquery/1.10.2/jquery'])
# </script>
```

如果需要给`seajs.use`传入回调，直接在 Slim 上写 js 代码，并借助`Array.to_cmd`：

```
javascript:
  seajs.use(#{{ ['foo', '#gallery/jquery/1.10.2/jquery'].to_cmd }}, function(Foo, $) {
    $(function() {
      console.log('%c一个粗心的程序员是不可能卓越的！', 'background:#000;color:#fff;font-size:64px')
    })
  })
```

## noncmd_include_tag(*sources)

引入`noncmd/`目录内的普通 js 文件（非 CMD 模块）。

比如引入`noncmd/foo.js`和`noncmd/bar.js`：

```ruby
= noncmd_include_tag 'foo', 'bar'
# <script src="/assets/noncmd/foo.js"></script>
# <script src="/assets/noncmd/bar.js"></script>
```

---

> :point_up: 以上 3 个 Helpers 会根据`Rails.env`自动调整线上、线下的路径，无需人工干预。:point_up:

---

## date_time(from_time, locale = I18n.locale)

把`Time.now`和`from_time`对比后输出自然语言，根据`locale`切换语种。`from_time`可传入字符串。

```ruby
= date_time 3.minutes.ago
# 3 分钟前

= date_time 1.day.ago
# 昨天 08:20

= date_time Time.now.tomorrow
# 09月04日 08:20

= date_time 1.year.ago
# 2012年09月03日 08:20

= date_time '2013-09-03 08:19:59'
# 刚刚
```

## geturl([new_pathname], operators = {})

处理当前页面的 Query String。功能类似 [jsUri](https://github.com/derek-watson/jsUri)

`operators`包括：

1. `keep_params`: 保留项，其余移除。
2. `remove_params`: 移除项，其余保留。如果传入空数组，则移除全部。
3. `edit_params`: 新增或替换。

```ruby
# 当前页面: /users?a[]=1&a[]=2&b=3&c=

= geturl keep_params: :a
# /users?a[]=1&a[]=2

= geturl keep_params: [:b, :c]
# /users?b=3&c=

= geturl remove_params: [:a, :c]
# /users?b=3

= geturl remove_params: []
# /users

= geturl edit_params: { a: [10, 20] }
# /users?a[]=10&a[]=20&b=3&c=

= geturl '/groups'
# /groups?a[]=1&a[]=2&b=3&c=

= geturl '/groups', edit_params: { a: 100 }, remove_params: [:b, :c]
# /groups?a=100
```

## to_compact_a(*args)

把不同类型的元素去空、去重后组成一个一维数组

```ruby
= to_compact_a({}, [], [[[]]], nil, false, '  ')
# []

= to_compact_a(:a, ['a'], 123, nil)
# ['a', '123']
```

---

> :point_up: 以上 3 个 Helpers 可同时用于 Controller。:point_up:

---

## flash_message(options = {})

输出 Flash Message，自动判断类型。

Controller 通过`flash[:type]`抛出消息内容，`type`仅支持`success`、`error`、`warn`、`info`四种。

消息内容可以是 [locale key](https://github.com/eDoctor/eRails/tree/2.x/templates/locales/flash)，也可以直接传入文字。需要多行显示时，传入数组即可。

```ruby
# Controller:
flash[:success] = :default
flash[:error] = 'Sorry, something went wrong!'
flash[:warn] = ['Warning!', 'Best check yo self, u r not looking too good.']
redirect_to root_path, info: 'Cooooool~~'

# View:
= flash_message
= flash_message class: 'ninja', id: nil
```

输出如下 HTML 结构：

```html
<div class="flash-message" id="j-flash">
  <div class="flash-warn">
    <p>Warning!</p>
    <p>Best check yo self, u r not looking too good.</p>
  </div>
</div>
```

想瞄一眼 UI 外观，请移步 [Sass Styleguide](http://edoctor.github.io/#/styleguide/sass) 页面底部。


---

> :point_down: 扩展 Rails 官方提供的 Helpers，包括`button`、`input`和`textarea`：:point_down:

---

## button_tag([value], options = {}, &block)
#### 和它的小伙伴们：`submit_tag` `reset_tag`

对比原版：:exclamation:

1. `value`可以是 [locale key](https://github.com/eDoctor/eRails/tree/2.x/templates/locales/button_tag)，也可以直接传入文字。如果没有传值，默认取与`type`同名的 locale key。
2. 固定`type`，不可更改。
3. 默认 className 为`btn`，可追加其他 className。

```ruby
= submit_tag
# <button type="submit" class="btn">Submit</button>

= reset_tag
# <button type="reset" class="btn">Reset</button>

= button_tag :login
# <button type="button" class="btn">Sign in</button>

= button_tag 'Delete', class: 'btn-danger'
# <button type="button" class="btn btn-danger">Delete</button>

= button_tag class: nil do
  = content_tag :strong, 'Click me!'
# <button type="button">
#   <strong>Click me!</strong>
# </button>
```

## text_field_tag(name, [value], options = {})
#### 和它的小伙伴们：`password_field_tag` `tel_field_tag` `date_field_tag` ...

Refer to [HTML &lt;input&gt; type Attribute](http://www.w3schools.com/tags/att_input_type.asp)

对比原版：:exclamation:

1. 添加了 Rails 4 中新增的类型。
2. `value`调整为可选参数。
3. 默认 className 为`input`，可追加其他 className。
4. 默认把`name`属性的值解析成`placeholder`。
5. `form_for`模式下去除了默认的`size`属性。

```ruby
= text_field_tag :user_name
# <input type="text" name="user_name" class="input" id="user_name" placeholder="User Name" />

= email_field_tag :email, class: 'email'
# <input type="email" name="email" class="input email" id="email" placeholder="Email" />

= hidden_field_tag :referrer, '/'
# <input type="hidden" name="referrer" value="/" id="referrer" />

= password_field_tag :password, '123456', class: nil, placeholder: nil
# <input type="password" name="password" value="123456" id="password" />
```

## text_area_tag(name, content = nil, options = {})

对比原版：:exclamation:

1. 默认 className 为`input`，可追加其他 className。
2. 默认把`name`属性的值解析成`placeholder`。
3. `form_for`模式下去除了默认的`cols`和`rows`属性。

```ruby
= text_area_tag :weibo
# <textarea name="weibo" class="input" id="weibo" placeholder="Weibo"></textarea>

= text_area_tag :weibo, '#人艰不拆#', rows: 5, placeholder: nil
# <textarea name="weibo" class="input" id="weibo" rows="5">#人艰不拆#</textarea>
```

---

> :point_up: 以上所有 xxx_tag helpers 的变动皆兼容`form_for`模式。:point_up:

---
