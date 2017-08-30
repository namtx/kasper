---
layout: post
title: "Observer pattern trong Ruby"
date: 2017-08-31 11:14:00
categories: Ruby, Design Pattern
---

### Observer Patter

Nếu bạn chưa từng nghe nói về `Observer Pattern` lần nào thì bạn cũng không nên lo lắng, nó đơn giản chỉ là cơ chế để một `object` thông báo đến các `object` khác khi mà trạng thái của nó thay đổi. Trích dẫn nguyên từ `Wikipedia`:

> The observer pattern (aka. Dependents, publish/subscribe) is a software design pattern in which an object, called the subject, maintains a list of its dependents, called observers, and notifies them automatically of any state changes, usually by calling one of their methods. It is mainly used to implement distributed event handling systems.

Trong `Ruby` đã có sẵn module `Observable` để chúng ta có thể dễ dàng sử dụng.

### The Planning

Để minh họa cho `Observer Pattern`, chúng ta sẽ đến với một ví dụ thường ngày đơn giản. Trong ví dụ này chúng ta sẽ kiểm soát trạng thái của chiếc xe của chúng ta (quãng đường đã đi,...), và hệ thống sẽ thông báo cho chúng ta biết lúc nào chúng ta cần đưa xe đi bảo dưỡng.
Một ví dụ đơn giản những mong nó sẽ giúp chúng ta hiểu rõ hơn về `Observer Patter`.

### The Basic Structure

Điều đầu tiên chúng ta cần làm là tạo ra một cấu trúc cơ bản cho `Notifier` class, nó sẽ đóng vai trò như `observer`. Điểm quan trọng mà bạn phải chú ý là `update()` method. Nó đóng vai trò như là một `callback` mà module `Observable` sẽ sử dụng khi thông báo các thay đổi đến các `observer`, và tên của method bắt buộc phải là `update`.

```ruby
class Notifier
  def update
  end
end
```

Đơn giản như vậy thôi. Tiếp theo, chúng ta sẽ tạo ra class `Car`:
```ruby
class Car
  attr_reader :milage, :service

  def initialize milage = 0, service = 3000
    @milage, @service = milage, service
  end

  def log miles
    @milage += miles
  end
end
```

Nó bao gồm 2 attributes `milage`, `service`, và 2 methods: `initialize()` và `log()`. `initialize()` method được dùng để khởi tạo giá trị. `log()` method sẽ ghi lại xe của chúng ta đã đi được bao nhiều dặm.

### Fixing the Notifier Class

Giờ chúng ta đã hiểu được class `Car` làm việc như thế nào. Bổ sung một số `logic` vào class `Notifier`:

```ruby
class Notifier
  def update car, miles
    puts "The car has logged #{miles} miles, totaling #{car.mileage} miles traveled."
    puts "The car needs to be taken in for a service!" if car.service <= car.mileage
  end
end
```

Đoạn `logic` trên sẽ giúp mỗi khi observer nhận được thông báo, sẽ in ra màn hình thông báo về số dặm mà xe đã đi, cũng như thông báo cần đưa đi xe đi bảo dưỡng nếu tổng số dặm vượt quá mức phải đưa xe đi bảo dưỡng.

### Putting It All Together

Chúng ta sẽ sử dụng module `Observable`:

```ruby
require "observer"

class Car
  include Observable
  ...
end
```

Tiếp theo chúng ta sẽ gắn vào mỗi xe mới một `observer`.

```ruby
def initialize mileage = 0, service = 3000
  @mileage, @service = mileage, service
  add_observer Notifier.new
end  
```

Cuối cùng chúng ta cần thông báo cho `observer` rằng `object` đã thay đổi:

```ruby
def log miles
  @mileage += miles
  changed
  notify_observers self, miles
end
```

Chúng ta gọi `changed`, hàm này sẽ set state của `object` thay đổi.
`notify_observers(self, miles)` giúp chúng ta thông báo sự thay đổi đó đến toàn bộ `observers`.

Kết lại, chúng ta có class `Car` như sau:

```ruby
require "observer"

class Car
  include Observable

  attr_reader :mileage, :service

  def initialize mileage = 0, service = 3000
    @mileage, @service = mileage, service
    add_observer Notifier.new
  end

  def log miles
    @mileage += miles
    changed
    notify_observers self, miles
  end
end
```

### Running the code

```ruby
car = Car.new 2300, 3000
car.log 100
=> "The car has logged 100 miles, totaling 2400 miles traveled."
car.log 354
=> "The car has logged 354 miles, totaling 2754 miles traveled."
car.log 300
=> "The car has logged 300 miles, totaling 3054 miles traveled."
=> "The car needs to be taken in for service!"
```
