---
layout: post
title:  "Tăng tốc Bundler bằng câu lệnh đơn giản"
date:   2017-07-26 10:18:00
categories: Ruby Rails Gem
image: http://media.tumblr.com/76501d7e366e32c68e05bf0e931206ac/tumblr_inline_ms7d9qF6Hb1qz4rgp.png
---

#### Lý do
Bạn có cảm thấy rằng bạn đang tốn quá nhiều thời gian cho việc chạy `bundle install`?
![](http://media.tumblr.com/76501d7e366e32c68e05bf0e931206ac/tumblr_inline_ms7d9qF6Hb1qz4rgp.png)

#### Giải pháp
Bạn không cần phải "Đấu kiếm" nữa. `Bundler` từ version `1.4.0` đã support việc install các bundle một cách song song.
Chỉ cần truyền `--jobs SIZE` vào `bundle config`. Có một điểm chú ý là bạn chỉ nên truyền setting `SIZE` nhỏ hơn 1 so với số lượng `CPU core` thực trên máy của bạn.

#### Nhưng giảm được bao nhiêu?
Sử dụng `benchmark`, chúng ta có thể biết được chúng ta tiết kiệm được bao nhiều thời gian.

Trước:
```
$ rvm gemset use j1 --create
Using ruby-2.0.0-p247 with gemset j1
$ time bundle install
# ... snip ...
bundle install  5.75s user 1.76s system 24% cpu 30.679 total
```

Sau:
```
$ rvm gemset use j8 --create
Using ruby-2.0.0-p247 with gemset j8
$ bundle config --global --jobs 8
$ time bundle install
# ... snip ...
bundle install  7.48s user 2.59s system 86% cpu 11.681 total
```
Vậy là chúng ta tiết kiệm được `19s`, tốc độ được cải thiện `~61,90%` so với việc `bundle install` thông thường.
#### Tuyệt vời, vậy làm cách nào để sử dụng
Bạn có thể config globally cho `Bundler`, lần sau không cần config nữa

```
bundle config --global jobs 7
```

Nếu bạn không chắc chắn là máy bạn có bao nhiều `CPU core` thì bạn có thể sử dụng cách sau để config một cách nhanh nhất:
```
number_of_cores=`lscpu | awk -F: '$1=="CPU(s)"{print $2;exit;}' | xargs`
bundle config --global jobs `expr $number_of_cores - 1`
```

Hoặc nếu cần bạn có thể
```
sudo vim ~/.bundle/config
```
để chỉnh sửa giá trị bằng tay.
Và bây giờ bạn có ít thời gian "Đấu kiếm" hơn rồi ;)
Bài viết mình tham khảo từ [thoughtbot](https://robots.thoughtbot.com/parallel-gem-installing-using-bundler) + chỉnh sửa lại cho phù hợp với `Ubuntu`.

Happy coding ;)
