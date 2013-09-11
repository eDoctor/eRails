# Path

若传入的值不是以`/`、`http:`、`https:`开头，则自动补全[`assets_dir`](https://github.com/eDoctor/eRails/blob/2.x/templates/config.example.yml#L4)。

## Sass: path(source, only_path=false)

```scss
background-image: path('ninja.png');
// background-image: url(/assets/{{ assets_dir }}/ninja.png);

background-image: path('/path/to/ninja.png');
// background-image: url(/path/to/ninja.png);

background-image: path('http://example.com/ninja.png');
// background-image: url(http://example.com/ninja.png);

$icons: sprite-map(path('icons/*.png', true));
```

## Ruby: String.path

```ruby
'ninja.png'.path
# {{ assets_dir }}/ninja.png

'/ninja.png'.path
# /ninja.png

'http://example.com/ninja.png'.path
# http://example.com/ninja.png

'ninja.png'.path(:exam)
# {{ assets_dir }}/plugin-exam/ninja.png
```

```ruby
= stylesheet_link_tag 'ninja'.path
# <link href="/assets/{{ assets_dir }}/ninja.css" rel="stylesheet" />

= image_tag 'ninja.png'.path
# <img src="/assets/{{ assets_dir }}/ninja.png" />
```
