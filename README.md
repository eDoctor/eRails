# 新建 Rails3.2+ 项目步骤
***

## Step 1

```bash
rails new APP --skip-bundle --skip-gemfile --skip-test-unit; cd APP
```

## Step 2

```bash
curl https://raw.github.com/eDoctor/eRails/master/templates/Gemfile > Gemfile
```

## Step 3

```bash
echo 'rvm use 1.9.3@APP --create' > .rvmrc
```

## Step 4

```bash
bundle install
```

## Step 5

```bash
rails g e_rails:install
```
