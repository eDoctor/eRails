# path
***

当传入 `/assets/` 或 `http` 开头的绝对路径时，原值输出，否则自动添加 `{{ assets_dir }}` 前缀。

## SCSS 中：path(source, only_path=false)

```css
background-image: path('ninja.png')
/* background-image: url(/assets/{{ assets_dir }}/ninja.png) */

background-image: path('/assets/ninja.png')
/* background-image: url(/assets/ninja.png) */

$icons: sprite-map(path('icons/*.png', true));
```

## View 中：String.path

```ruby
"ninja".path
# "{{ assets_dir }}/ninja"

"/assets/ninja.png".path
# "/assets/ninja.png"
```

```ruby
= stylesheet_link_tag "ninja".path
# <link href="/assets/{{ assets_dir }}/ninja.css" rel="stylesheet" />

= image_tag "ninja.png".path
# <img src="/assets/{{ assets_dir }}/ninja.png" />
```
