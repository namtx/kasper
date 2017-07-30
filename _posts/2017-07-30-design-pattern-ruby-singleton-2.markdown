---
layout: post
title:  "[Series-DesignPatternInRuby] Singleton - Phần 2"
date:   2017-07-30 10:18:00
categories: Ruby DesignPattern
image: http://media.tumblr.com/76501d7e366e32c68e05bf0e931206ac/tumblr_inline_ms7d9qF6Hb1qz4rgp.png
---

Đây là phần 2 về Singleton Pattern trong Series DesignPatternInRuby mà mình muốn giới thiệu với mọi người. Bạn có thể tham khảo phần 1 tại đây: [[Series-DesignPatternInRuby] Singleton - Phần 1](https://viblo.asia/p/series-designpatterninruby-singleton-phan-1-E375zb1W5GW)
### Alternatives to the Classic Singleton
Như phần trước chúng ta đã tìm hiểu về cách xây dựng `Singleton` bằng cách đưa quyền quản lý `instance` cho `class`, nhưng bạn cũng có thể sử dụng những cách khác, mà vẫn có thể có được hiệu quả tương tự.
#### Global Variables as Singleton
Chúng ta có thể sử dụng một `global variable` như một `singleton`.
Trong Ruby bất cứ biến nào bắt đầu bằng dấu `$` thì sẽ là một `global variable`. Một `global variable` mang những yếu tố để nó có trở thành phương án tốt để xây dựng `singleton`. `Global variable` thỏa mãn các điều kiện: chỉ có một `instance`, có thể truy xuất tại mọi nơi trong chương trình của bạn.
Nhưng, không! `Global variable` vẫn thiếu những tính chất cần thiết để trở thành `singleton`. Vì `global variable` luôn luôn trỏ đến 1 `object`, không có cách nào có thể kiểm soát được gía trị của nó.
```ruby
$logger = SimpleLogger.new
```
nhưng bạn không thể kiểm soát được việc gán `$logger` cho một gía trị khác.
```ruby
$logger = LoggerThatDoesSomethingBad.new
```
Nhưng nếu việc thay đổi giá trị là vấn đề thì chúng ta có thể sử dụng một loại biến trong `Ruby` vừa có có `scope` là `global`, mà còn không thể thay đổi giá trị: `constant`.
```ruby
Logger = SimpleLogger.new
```
Nhưng liệu `constant` có thể giúp chúng ta xây dựng được `Singleton`, câu trả lời là:
> Không hẳn
>
Có một số điểm mà `global variable` cũng như `constant` không thể giúp chúng ta sử dụng được `Singleton`:
+ Không có cách nào giúp chúng ta có thể `delay` việc khởi tạo `instance`
+ Không đảm bảo được việc tạo chỉ tạo được duy nhất một `instance` của `class`
Có một cách khá *hack* đó là sau khi tạo ra `instance` của `class`, chúng ta sẽ thay đổi `class` đó đi, và sau đó, việc khởi tạo `instance` khác sẽ là không thể. Nhưng phương án này chỉ nói ra thôi cũng thấy *hack não* rồi. (yaoming)
#### Class as Singleton
Như chúng ta đã thấy, chúng ta có thể define `method` và `ariables`trực tiếp trên `class`. Thực tế, như phần 1 đã giới thiệu thì chúng ta đã implement `singleton` bằng `class method` và `class variables` để quản lý `singleton instance`. Vậy, nếu class cũng có riêng các `method` và các `variables` thì tại sao không nghĩ đến việc là chỉ cần dùng `class` thôi.
+ Mỗi `class` là duy nhất.

```
class ClassBasedLogger
    ERROR = 1
    WARNING = 2
    INFO = 3

    @@log = File.open('log.txt', 'w')
    @@level = WARNING

    def self.error msg
        @@log.puts msg
        @@log.flush
    end

    def self.warning msg
        @@log.puts(msg) if @@level >= WARNING
        @@log.flush
    end

    def self.info msg
        @@log.puts(msg) if @@level >= INFO
        @@log.flush
    end

    def self.level= new_level
        @@level = new_level
    end
end
```
Sử dụng:
```
ClassBasedLogger.level = ClassBasedLogger::INFO
ClassBasedLogger.info 'Computer wins chess game'
ClassBasedLogger.warning 'AE-35 hardware failure predicted.'
ClassBasedLogger.error 'HAL-9000 malfunction, take emergency action!'
```
Kỹ thuật `Class as Singleton` được trình bày ở trên vượt trội hơn `global variable` và `constant methods`:
+ Chắc chắn là chỉ có một `instance`
+ Mặc dù vấn đề `Lazy initialization` vẫn chưa được giải quyết, tuy nhiên: `Class` chỉ được khởi tạo khi mà nó được `load` (thường là ai đó `require` file chứa `class`). Bạn không cần phải kiểm soát thời điểm mà nó được khởi tạo.

Nhược điểm của kĩ thuật này là gì? Đó là
> Code có vẻ khó đọc hơn với những người cảm thấy lạ với `self` và `@@` variable.
>
#### Modules as Singletons
Có một phương pháp khác nữa là: sử dụng `Module`. `Module` có rất nhiều nét tương đồng với `Class`, chúng ta có thể tạo ra class `module-level` `methods` cũng như `variable` giống hệt cách mà chúng ta tạo `class-level` `methods`, `variables`.
```
module ModuleBasedLogger
    ERROR = 1
    WARNING = 2
    INFO = 3

    @@log = File.open 'log.txt', 'w'
    @@level = WARNING

    def self.error msg
        @@log.puts msg
        @@log.flush
    end
    ...
    # Giống hệt các method như class ClassBasedLogger trên
    ...
end
```
Sử dụng hoàn toàn tương tự:
```
ModuleBasedLogger.info 'Computer wins chess game.'
```
Nhưng có một điểm khá quan trọng ở `Module` mà `Class` không có, đó là chúng ta không thể tạo `instance` từ `Module`. Code của chúng ta khi sử dụng `Module` sẽ clear hơn.
### To be continued...
Phần 2 mình xin kết thúc tại đây. Mình sẽ quay lại với phần 3 sớm.
Ghé đọc các bài viết của mình tại [namtx.github.io](https://namtx.github.io)
Happy coding ;)
