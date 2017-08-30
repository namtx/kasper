---
layout: post
title: "Airbnb JS Style Guide - ECMAScript 6+ (ES 2015+) Styles"
date: 2017-08-24 11:14:00
categories: Javascript
---


ng quá trình viết JS, nhiều người chắc ai cũng gặp phải nhiều vấn đề về Style có cho JS đặc biệt là chuẩn ECMAScript 6, không biết viết sao cho đúng chuẩn.
Trong bài viết này mình sẽ giới thiệu về style viết JS của công ty [Airbnb](https://www.airbnb.com/). Mong sau bài viết này mọi người sẽ tìm ra được style chuẩn cho mình để code khoa học, đẹp hơn.
### Arrow Functions
1. Khi bạn bắt buộc phải sử dụng `function expressions` (truyền vào một `anonymous function`), hãy sử dụng `arrow function notation`.

> **Vì sao nên?**
> `Arrow function` tạo ra một `function`, `function` này thực thi trong `context` của `this`, bạn sẽ không còn phải truyền `this` thông qua một `that` nào nữa. Cú pháp cũng ngắn gọn hơn.
>

> **Vì sao không nên?**
> Nếu bạn có một `function` mà logic quá phức tạp, bạn nên tách `function` đó ra ngoài sẽ tốt hơn.
>

```js
// bad
[1, 2, 3].map(function (x) {
  const y = x + 1;
  return x * y;
});

// good
[1, 2, 3].map((x) => {
  const y = x + 1;
  return x * y;
});
```

2. Nếu function chỉ có duy nhất một câu lệnh `return`, không tồn tại `side effects`, thì hãy bỏ `{ }`, và bỏ luôn từ khóa `return`. Nếu không hãy giữ `{ }` và để lại `return`

> **Tại sao?**
> Nó tốt hơn cho việc nối nhiều `function` lại với nhau
>

```js
// bad
[1, 2, 3].map(number => {
  const nextNumber = number + 1;
  `A string containing the ${nextNumber}.`;
});

// good
[1, 2, 3].map(number => `A string containing the ${number}.`);

// good
[1, 2, 3].map((number) => {
  const nextNumber = number + 1;
  return `A string containing the ${nextNumber}.`;
});

// good
[1, 2, 3].map((number, index) => ({
  [index]: number,
}));

// No implicit return with side effects
function foo(callback) {
  const val = callback();
  if (val === true) {
    // Do something if callback returns true
  }
}

let bool = false;

// bad
foo(() => bool = true);

// good
foo(() => {
  bool = true;
});
```

3. Trong trường hợp biểu thức tràn xuống dòng, nên sử dụng `( )` cho dễ đọc.
> **Tại sao?**
> Người đọc code sẽ biết được đâu là nơi bắt đầu, nơi kết thúc của `function`
>

```js
// bad
['get', 'post', 'put'].map(httpMethod => Object.prototype.hasOwnProperty.call(
    httpMagicObjectWithAVeryLongName,
    httpMethod,
  )
);

// good
['get', 'post', 'put'].map(httpMethod => (
  Object.prototype.hasOwnProperty.call(
    httpMagicObjectWithAVeryLongName,
    httpMethod,
  )
));
```

4. Nếu `function` chỉ có 1 tham số duy nhất, hãy bỏ dấu `( )` đi, ngược lại hãy luôn sử dụng `( )` cho nó `an toàn` (hehe)
> **Vì sao?**
> Bỏ bớt cho code sạch đẹp hơn.
>

```js
// bad
[1, 2, 3].map((x) => x * x);

// good
[1, 2, 3].map(x => x * x);

// good
[1, 2, 3].map(number => (
  `A long string with the ${number}. It’s so long that we don’t want it to take up space on the .map line!`
));

// bad
[1, 2, 3].map(x => {
  const y = x + 1;
  return x * y;
});

// good
[1, 2, 3].map((x) => {
  const y = x + 1;
  return x * y;
});
```

5. Tránh việc dễ hiểu nhầm giữa `=>` và toán tử so sánh `<=`, `>=`

```js
// bad
const itemHeight = item => item.height > 256 ? item.largeSize : item.smallSize;

// bad
const itemHeight = (item) => item.height > 256 ? item.largeSize : item.smallSize;

// good
const itemHeight = item => (item.height > 256 ? item.largeSize : item.smallSize);

// good
const itemHeight = (item) => {
  const { height, largeSize, smallSize } = item;
  return height > 256 ? largeSize : smallSize;
};
```
### Classes & Constructors

1. Luôn luôn sử dụng `class`, tránh việc sử dụng `prototype`

> **Tại sao?**
> Cú pháp của `class` ngắn gọn và dễ dàng hơn.
>

```js
// bad
function Queue(contents = []) {
  this.queue = [...contents];
}
Queue.prototype.pop = function () {
  const value = this.queue[0];
  this.queue.splice(0, 1);
  return value;
};

// good
class Queue {
  constructor(contents = []) {
    this.queue = [...contents];
  }
  pop() {
    const value = this.queue[0];
    this.queue.splice(0, 1);
    return value;
  }
}
```
2. Sử dụng `extends` cho thừa kế trong `JS`
> **Tại sao?**
> Tránh gặp các vấn đề về `instanceof`
>

```js
// bad
const inherits = require('inherits');
function PeekableQueue(contents) {
  Queue.apply(this, contents);
}
inherits(PeekableQueue, Queue);
PeekableQueue.prototype.peek = function () {
  return this.queue[0];
};

// good
class PeekableQueue extends Queue {
  peek() {
    return this.queue[0];
  }
}
```
3. Trong trường hợp muốn sử dụng `chains functions`, hãy sử dụng `return this`

```js
// bad
Jedi.prototype.jump = function () {
  this.jumping = true;
  return true;
};

Jedi.prototype.setHeight = function (height) {
  this.height = height;
};

const luke = new Jedi();
luke.jump(); // => true
luke.setHeight(20); // => undefined

// good
class Jedi {
  jump() {
    this.jumping = true;
    return this;
  }

  setHeight(height) {
    this.height = height;
    return this;
  }
}

const luke = new Jedi();

luke.jump()
  .setHeight(20);
```

4. Bạn có thể sử dụng `method` `toString()`, những hãy đảm bảo là nó chạy ngon lành, và không xuất hiện `side effects`

```js
class Jedi {
  constructor(options = {}) {
    this.name = options.name || 'no name';
  }

  getName() {
    return this.name;
  }

  toString() {
    return `Jedi - ${this.getName()}`;
  }
}
```
5. Mỗi `class` đều có một `default constructor` nếu không khai báo. `Constructor` rỗng hoặc `delegate` đến `parent class` là không cần thiết.

```js
// bad
class Jedi {
  constructor() {}

  getName() {
    return this.name;
  }
}

// bad
class Rey extends Jedi {
  constructor(...args) {
    super(...args);
  }
}

// good
class Rey extends Jedi {
  constructor(...args) {
    super(...args);
    this.name = 'Rey';
  }
}
```

6. Tránh việc lặp `class member`

> **Tại sao?**
> Nó sẽ luôn luôn lấy `member` khai báo sau, nhưng đôi khi cũng trả về một đống `bug`
>


```js
// bad
class Foo {
  bar() { return 1; }
  bar() { return 2; }
}

// good
class Foo {
  bar() { return 1; }
}

// good
class Foo {
  bar() { return 2; }
}
```
### Modules
1. Luôn luôn sử dụng `modules` (`import/ export`)

> **Tại sao?**
> Cái nào mới thì mình dùng thôi
>


```js
// bad
const AirbnbStyleGuide = require('./AirbnbStyleGuide');
module.exports = AirbnbStyleGuide.es6;

// ok
import AirbnbStyleGuide from './AirbnbStyleGuide';
export default AirbnbStyleGuide.es6;

// best
import { es6 } from './AirbnbStyleGuide';
export default es6;
```

2. Không nên sử dụng `wildcard` trong `import`
> **Tại sao?**
> Nó chắc chắn việc bạn chỉ import 1 lần duy nhất


```js
import * as AirbnbStyleGuide from './AirbnbStyleGuide';

// good
import AirbnbStyleGuide from './AirbnbStyleGuide';
```
3. Không `export` trực tiếp những thứ vừa `import`

```js
// bad
// filename es6.js
export { es6 as default } from './AirbnbStyleGuide';

// good
// filename es6.js
import { es6 } from './AirbnbStyleGuide';
export default es6;
```
4. `import` 1 path 1 lần ở 1 nơi thôi
> **Tại sao?**
> Khó maintain lắm.
>

```js
// bad
import foo from 'foo';
// … some other imports … //
import { named1, named2 } from 'foo';

// good
import foo, { named1, named2 } from 'foo';

// good
import foo, {
  named1,
  named2,
} from 'foo';
```

5. Không nên sử dụng `export` cho `mutabel bindings`
> **Tại sao?**
> Tuy một số trường hợp có thể dùng, nhưng nên `export` `const` thì tốt hợn
>

```js
// bad
let foo = 3;
export { foo };

// good
const foo = 3;
export { foo };
```
6. Nếu `module` chỉ `export` 1 chỗ thì nên sử dụng `export default` hơn là `named export`.

> **Vì sao?**
> Việc này khuyến khích việc tách ra từng `module`, code dễ đọc, bảo trì hơn.
>

```js
// bad
export function foo() {}

// good
export default function foo() {}
```

7. Luôn luôn bỏ câu lệnh `import` lên trên cùng

> **Vì sao?**
> Vì `import` có hiện tượng `hoisted` nên bỏ lên trên cùng để tránh những `issue` không mong muốn.
>

```js
// bad
import foo from 'foo';
foo.init();

import bar from 'bar';

// good
import foo from 'foo';
import bar from 'bar';

foo.init();
```
8. Với import trên nhiều dòng, thì nên xuống dòng

> **Vì sao?**
> Dễ đọc hơn
>

```js
// bad
import {longNameA, longNameB, longNameC, longNameD, longNameE} from 'path';

// good
import {
  longNameA,
  longNameB,
  longNameC,
  longNameD,
  longNameE,
} from 'path';
```

9. Không cho phép `Webpack syntax` trong việc `import`

```js
// bad
import fooSass from 'css!sass!foo.scss';
import barCss from 'style!css!bar.css';

// good
import fooSass from 'foo.scss';
import barCss from 'bar.css';
```

###
> Tobe continued...
