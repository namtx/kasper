---
layout: post
title:  "Tạo notification nhắc nhở uống nước trên Ubuntu"
date:   2017-07-21 10:18:00
categories: Bash Ubuntu
---

Làm cái nghề coder, ngồi trên ghế suốt hơn 8 tiếng mỗi ngày thì tư thế ngồi là rất quan trọng, một tư thế đúng sẽ giúp chúng ta tránh được đau mỏi cũng như các vấn đề về xương khác. Một điều nữa cũng quang trọng không kém là uống nước đều đặn.
Đôi lúc, vì mải say mê fix bug mà chúng ta quên uống nước, ngồi sai tư thế. Không những có hại cho sức khỏe mà còn làm giảm hiệu suất làm việc.

Dựa trên những điều đó mình đã tìm hiểu và viết một đoạn script nhỏ để có thể nhắc nhở được mình ngồi đúng tư thế cũng như uống nước đều đặn.

## Vấn đề
Mỗi 15 phút thì máy tính sẽ tự động gửi một notification nhắc nhở việc ngồi đúng tư thế và uống nước.
## Cách giải quyết.
##### Tạo file water.sh

```
eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)";
DISPLAY=:0 notify-send "Hey, Tran Xuan Nam" "Keep your back straight and drink water!"
```

Đặt file này ở bất kìa đâu, nhớ đừng xóa là được ^^
##### Cấp quyền executable cho water.sh

```
sudo chmod +x /path/to/water.sh
```
##### Test notification thử
```
$ /path/to/water.sh
```

##### Tạo job với crontab
```
$ crontab -e
```

Edit lại file `config` như sau:

```
*/15 * * * * /path/to/water.sh
```
### Enjoy your healthy life! ^^

[Link Git của mình ^^](https://github.com/tranxuannamframgia/water-your-body/blob/master/README.md)
##### Thanks for reading!
