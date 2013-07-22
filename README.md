# 新建 Rails 3.x 项目步骤
***

## Step 1

```bash
rails new APP --skip-bundle --skip-gemfile --skip-test-unit
```

## Step 2

```bash
echo 'rvm use 1.9.3@APP --create' > APP/.rvmrc
```

## Step 3

```bash
cd APP
curl https://raw.github.com/eDoctor/eRails/2.x/templates/Gemfile > Gemfile
```

## Step 4

```bash
bundle
```

## Step 5

```bash
rails g e_rails:install
```
