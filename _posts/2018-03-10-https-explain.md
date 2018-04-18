---
layout: post
title:  "HTTPS Explaination"
date:   2018-02-21 10:18:00
categories: Bash Ubuntu
---


Trong hành trình trở thành một `Fullstack Developer` thì việc tìm hiểu những khái niệm cơ bản là điều vô cùng cần thiết.

Bài viết này tìm hiểu một khái niệm vô cùng quan trọng mà tất cả các `Fullstack Developer` đều phải nắm vững, đó là `HTTPS`.

### Alice, Bob and..pigeons?
Tất cả những hoạt động của bạn trên `Internet` (đọc sách, báo, post hình sống ảo trên `Facebook`,...), tất cả những hoạt động đó đều dựa trên việc gửi và nhận các messages từ (đến) Server.

Đọc đến đoạn này có vẻ hơi trừu tượng, vậy nên hãy lẫy việc gửi thư bồ câu làm ví dụ, mặc dù hơi có vẻ tùy ý, nhưng hãy đọc tiếp để thấy nó gần gũi với nhau như thế nào, trừ việc HTTPS nhanh hơn rất nhiều lần.

### A first naive communication
Chuyện kể rằng nàng `Alice` xinh đẹp đã đến tuổi trăng tròn, nàng đem lòng yêu chàng `Bob`, hôm nay, cả nhà nàng đi ra ngoài, chỉ còn nàng ở nhà một mình. Nàng chợt nghĩ đến `Bob` và gửi cho nàng một tin nhắn:
> Hôm nay, không có ai ở nhà, đến chơi với em anh nhé.
>

`Alice` viết tin nhắn vào giấy và nhờ chú chim...bồ câu của mình gửi đến `Bob`, mọi chuyện sẽ diễn ra tốt đẹp nếu chim...bồ câu đến được `Bob`, chàng sẽ đọc được tin nhắn của nàng và cả 2 người có một ngày thật vui vẻ bên nhau.

Tuy nhiên, mọi việc sẽ luôn dễ dàng như vậy nếu không có một chàng `Mallory` đem lòng thầm thương trộm nhớ nàng `Alice`. `Mallory` đã dùng máy bay, tráo đổi message mà `Alice` đã gửi thành.
> Ahihi, thằng cờ hó.
>

`Bob` sẽ không hề biết là tin nhắn mà `Alice` gửi đã bị thay đổi, chàng sẽ mất cơ hội được chơi...với nàng ấy.

Đó là cách mà `HTTP` vẫn đang làm việc hằng ngày, quá nguy hiểm, đúng không? Sẽ ra sao nếu thông tin cách giao dịch ngân hàng của bạn bị thay đổi.

### A secret code

Nhưng chuyện gì xảy ra `Alice` và `Bob` là những `Fullstack Developer` chính hiệu? Họ sẽ sử dụng `Secret Code` để mã hóa tin nhắn của họ. Chẳng bạn họ sẽ dịch những chữ cái sang phải 3 vị trí trong bảng chữ cái.

```
D -> A
E -> B
F -> C
```

Như vậy tin nhắn `Toi nay 9h, phong em anh nhe` sẽ biến thành `Qlf kxv 9e, melkd bj keb xke`

Khi `Mallory` khi đọc được tin nhắn này, hắn ta sẽ không thể hiểu được tin nhắn mà `Alice` viết cho `Bob` là gì, và cũng không thể viết được một tin nhắn có nội dung có nghĩa để đưa lại cho `Bob`, bởi khi nhận được tin nhắn từ chim...bồ câu thì `Bob` sẽ thực hiện việc `decrypt` lại một lần nữa:

```
A -> D
B -> E
C -> F
```

Tin nhắn `Qlf kxv 9e, melkd bj keb xke` sẽ được dịch lại thành `Toi nay 9h, phong em anh nhe`, `Alice` và `Bob` lại có một đêm hạnh phúc bên nhau (hihi).

`Secret Code` được trình bày ở trên là `Caesar cipher`. Trong thực tế `Secret Code` phức tạp hơn rất nhiều lần, tuy nhiên, ý tưởng chung thì giống nhau.

### How do we decide the key?

Việc sử dụng `Secret Code` như trên sẽ rất tuyệt vời nếu trong trường không ai biết `Secret Code` ngoài `Alice` và `Bob`. Trong `Ceasar cipher`, `Secret Code` chính là số kí tự sẽ được dịch, trường hợp trên là `3`, tuy nhiên chúng ta có thể sử dụng 4 hoặc thậm chí là `12`.

Vấn đề ở đây là: nếu `Alice` và `Bob` chưa hề gặp nhau trước khi bắt đầu hú hí với nhau thì sẽ 2 bên sẽ không thể biết được `Secret Code` mà 2 bên sẽ sử dụng. Nếu cả 2 bên gửi `Secret Code` này cho nhau thì `Mallory` sẽ lấy được nó và lưu lại để `decrypt` những tin nhắn sau này của 2 người.

Đó là ví dụ của khái niệm gọi là `Man in the Middle Attack`, và giải pháp được đưa ra ở đây là thay đổi hệ thống mã hóa.

### Pigeons carrying boxes

`Alice` và `Bob` quyết định sẽ thay đổi phương thức hú hí của mình bằng cách khác. Khi không có ai ở nhà và `Alice` muốn gửi cho tin nhắn cho `Bob` cô sẽ:
+ `Alice` gửi cho `Bob` một chú chim...bồ câu mà không có tin nhắn nào.
+ `Bob` sẽ dùng chú chim...bồ câu này, với một chiếc hộp mở, `Bob` sẽ giữ chìa khóa của hộp này.
+ `Alice` đưa tin nhắn của mình vào trong hộp này, đóng khóa hộp và nhờ chú chim...bồ câu trả lại cho `Bob`.
+ `Bob` sẽ nhận lại chiếc hộp, dùng chìa khóa lúc nãy để mở hộp và đọc tin nhắn.


Bằng cách này `Mallory` sẽ không thể thay đổi được tin nhắn do không thể mở hộp để đọc và sửa tin nhắn được.

Nếu `Bob` muốn gửi tin nhắn lại cho `Alice` thì anh cũng sẽ làm tương tự.

Việc mà `Alice` và `Bob` làm trên được gọi là `asymmetric key cryptography`, bởi vì mặc dù có thể `encrypt` được tin nhắn (đóng hộp), nhưng không thể `decrypt` được tin nhắn đó (mở hộp). Theo ngôn ngữ `technical`, nó được gọi `public key` và `private key`.

### How do I trust the box?

Nếu bạn để ý, thì vẫn còn vấn đề trong cách gửi tin nhắn. Đó là, khi mà `Bob` nhận được chiếc hộp, làm cách nào mà anh có thể biết được đó là chiêc hộp mà `Alice` đã gửi cho mình thay vì chiếc hộp của `Mallory` đã đổi nó, và cầm chìa khóa?

`Alice` quyết định sẽ đánh dấu chiếc hộp của mình, khi `Bob` nhận được chiếc hộp, anh sẽ kiểm tra dấu hiệu này và xác nhận đó có phải là hộp của `Alice` đã gửi cho mình hay không.

Một vài người sẽ thắc mắc mà làm sao `Bob` có thể nhận ra được chiếc hộp của `Alice` trong lần đầu tiên. Cả `Bob` và `Alice` cũng nhận ra vấn đề này. Và thay vì `Alice` sẽ ghi dấu hiệu này lên hộp thì sẽ có một người khác làm việc này: `Ted`.

`Ted` sẽ ghi dấu hiệu lên chiếc hộp của `Alice` sau khi đã xác nhận `Alice` là chủ nhận của chiếc hộp, `Mallory` sẽ không thể có chiếc hộp thứ 2 có dấu hiệu của `Alice`, khi mà `Ted` chỉ ghi dấu hiệu khi xác thực chiếc hộp là chính chủ.

Trong hiện thực thì `Ted` chính là **Certification Authority**

Vậy nên, lúc bạn truy cập vào một website nào đó lần đầu tiên, bạn sẽ tin tưởng chiếc hộp của website đó, bởi vì bạn tin tưởng vào `Ted`, và `Ted` nói rằng chiếc hộp của website đó là chính chủ.

### Boxes are heavy

Bây giờ, `Alice` và `Bob` đã có một hệ thống tin nhắn ngon lành, họ có thể hú hí với nhau bất cứ lúc nào nhà `Alice` không có ai. Tuy nhiên, họ nhận ra rằng việc truyền tin bằng những chiếc hộp như thế này sẽ chậm hơn nhiều so với việc chỉ gửi tin nhắn như lúc trước.

Họ quyết định, sẽ chỉ dùng những cái hộp khi mà họ muốn trao đổi key để mã hóa tin nhắn, sau khi key được 2 bên nắm rõ thì chỉ cần trao đổi tin nhắn đã được mã hóa mà thôi.

Phương thức này đảm bảo cho tính bảo mật, tuy nhiên, vẫn đảm bảo được tốc độ, và đó là cách mà thế giới đang sử dụng `HTTPS`.

### Conclusion
Mặc dù những khái niệm sử dụng hằng ngày nhưng nếu không để ý thì chúng ta sẽ không biết được những vấn đề đăng sau nó cũng như cách giải quyết những vấn đề đó như thế nào. 
