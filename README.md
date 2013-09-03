# 新建 Rails 3.2.x 项目步骤

## Step 1

```sh
rails new Ninja -G -J -O -T --skip-gemfile --skip-bundle
```

## Step 2

```sh
echo 'rvm use 1.9.3@Ninja --create' > Ninja/.rvmrc
```

## Step 3

```sh
cd Ninja
curl https://raw.github.com/eDoctor/eRails/2.x/templates/Gemfile > Gemfile
```

## Step 4

```sh
bundle
```

## Step 5

```sh
rails g e_rails:install
```
