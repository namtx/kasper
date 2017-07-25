---
layout: post
title:  "Tôi đã viết Gem đầu tiên của mình như thế nào?"
date:   2017-07-25 10:18:00
categories: Ruby Rails Gem
---

## Lý do
Mỗi lần tạo mới một `Rails` project, do là người thích sự hoàn hảo, nên mình thường dành ra một chút thời gian để beautify lại `Gemfile`,
Lúc ban đầu tạo một project thì Gemfile sẽ như thế này:
```ruby
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

```
Lúc đó, trước khi code mỗi project mình thường phải tự beautify lại Gemfile này. Nó bao gồm các công việc như:
-  Xóa các dòng comment
-  Thay thế dấu `'` bằng `"`
-  Remove các dòng trống

Lặp đi lặp lại các công việc nhàm chán đó là điều không mấy thú vị.
Vào một ngày đẹp trời, chán việc phải chỉnh bằng tay, mình chợt nảy ra ý tưởng viết một `Gem` để thực hiện công việc này một cách tự động, và thế là gem `gf_beauty` ra đời.
## Thực hiện
### Gemspec
Đầu tiên chúng ta cần tạo một file `gemspec` như sau:

```ruby
Gem::Specification.new do |s|
  s.name        = "gf_beauty"
  s.version     = "1.0.9"
  s.date        = "2017-06-02"
  s.summary     = "Gemfile Beautify"
  s.description = "A simple gem which will beautify your Gemfile"
  s.authors     = ["Tran Xuan Nam"]
  s.email       = "tran.xuan.nam@framgia.com"
  s.files       = ["lib/gf_beauty.rb"]
  s.executables << "gf_beauty"
  s.homepage    =
    "https://rubygems.org/gems/gf_beauty"
  s.license       = "MIT"
end
```
Trong đó:
- `name` là tên của `gem` mình muốn tạo. Chú ý là tên này không được trùng lặp với gem trên trang [http://guides.rubygems.org](http://guides.rubygems.org)
- `version` là version của gem
- `date` là ngày tháng tạo gem
-  `summary` , `description` là tóm tắt về chức năng của gem
-  `authors`, `email` là thông tin về tác giả của gem
-  `files` đây là danh sách các file dùng để xây dựng gem
-  `executables` vì gem của mình viết dùng để chạy bằng `command line` nên cần phải đưa vào tên của command line mà tôi mình để người dùng có thể chạy (hơi lan man, phần sau mình sẽ hướng dẫn kĩ hơn)
-  `homepage`, `license` các thông tin thêm cho gem

Sau khi tạo được xong file `gemspec` chúng ta sẽ đến phần viết implement chức năng cho gem.
### lib/gf_beauty.rb
```ssh
❯ touch lib/gf_beauty.rb
```
```ruby
class GfBeauty
  def self.process
    current_project = `pwd`
    current_project = current_project.gsub(/\n/,"")
    content = File.read(current_project + "/Gemfile")
    content = content.gsub(/\#\s.*\s*/,"")
    content = content.gsub(/'/, '"')
    content = content.gsub(/\s*^group/, "\n\ngroup")
    content = content.gsub(/\s*^\s+^gem/, "\n\ngem")
    File.open(current_project + "/Gemfile", "w") do |file|
      file.puts content
    end
    system "echo", "-e", "\e[92mYour Gemfile was successfully beautified!"
  rescue Exception => e
    system "echo", "-e", "\e[91m#{e.message}"
    system "echo", "-e", "\e[91mMake sure you're in the right place!"
  end
end
```
Do gem của mình sau khi người dùng cài đặt, họ có thể chạy bằng Command Line như thế này:
```ssh
❯ gf_beauty
```

Vậy nên, mình phải tạo một executable file thực hiện.
### bin/gf_beauty
```ssh
❯ touch bin/gf_beauty
```
Công việc của file này rất đơn giản, nó sẽ gọi đến thư viện mà chúng ta đã viết ở trên.
```ruby
#!/usr/bin/env ruby

require "gf_beauty"

GfBeauty.process
```
Dùng lệnh `chmod` để file này có thể thực thi từ `Command Line`
```ssh
❯ sudo chmod a+x bin/gf_beauty
```

Đến bước này, cơ bản là chúng ta đã hoàn thành gem file của mình.
## Publish
Đầu tiên chúng ta cần tạo một tài khoản ở trên trang [https://rubygems.org](https://rubygems.org) để có thể publish gem lên trên đó.
Sau khi tạo tài khoản xong, đăng nhập ở local bằng `Command Line`:
```ssh
❯ curl -u your_user_name https://rubygems.org/api/v1/api_key.yaml >~/.gem/credentials; chmod 0600 ~/.gem/credentials
Enter host password for user 'your_user_name':
```
Nhập account mà bạn vừa đăng kí vào. Đến đây bạn có thể publish gem từ local lên https://rubygems.org bằng `Command Line` được rồi.

Tiếp theo, chúng ta cần `build` `gemspec`
```ruby
❯ gem build gf_beauty.gemspec
  Successfully built RubyGem
  Name: gf_beauty
  Version: 1.0.9
  File: gf_beauty-1.0.9.gem
```

Sau đó là push lên https://rubygems.org bằng:
```ssh
❯ gem push gf_beauty-1.0.9.gem
Pushing gem to https://rubygems.org...
Successfully registered gem: gf_beauty (1.0.9)
```
## Sử dụng
Đến đây, bạn có thể sử dụng gem của mình vừa `publish` lên rồi.
```ssh
❯ gem install gf_beauty
```
```ruby
❯ gf_beauty
```
Bùm, file `Gemfile` của bạn sạch sẽ tinh tươm.
```ruby
source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.0.3"
gem "sqlite3"
gem "puma", "~> 3.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.2"
gem "jquery-rails"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.5"

group :development, :test do
  gem "byebug", platform: :mri
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```
## Kết luận

Tuy là gem đơn giản, phục vụ mục đích cá nhân là nhiều, nhưng qua đây mình học được cách đưa gem chính chủ của mình lên https://rubygems.org để người khác có thể sử dụng.
Toàn bộ source mình publish lên để các bạn có thể theo dõi, nhớ star cho repo của mình nếu cảm thấy có ích nhé (honho)
[https://github.com/namtx/gf_beauty](https://github.com/namtx/gf_beauty)

Happy coding ;)
