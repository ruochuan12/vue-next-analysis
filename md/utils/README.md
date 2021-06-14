---
theme: smartblue
highlight: dracula
---

# Vue 3 中 那些实用的工具函数

## 1. 前言

57个工具函数

写相对很难的源码，耗费了自己的时间和精力，也没收获多少阅读点赞，其实是一件挺受打击的事情。

所以转变思路，写一些相对通俗易懂的文章。其实源码也不是想象的那么难，至少有很多看得懂。比如工具函数。

阅读本文，你将学到：

```js
1. 如何学习 JavaScript 基础知识，会推荐很多学习资料
2. 如何学习源码中优秀代码和思想，投入到自己的项目中
3. Vue 3 源码 shared 模块中的几十个实用工具函数
4. 我的一些经验分享
```

## 2. 环境准备

打开 [vue-next](https://github.com/vuejs/vue-next)，
开源项目一般都能在 `README.md` 或者 [.github/contributing.md](https://github.com/vuejs/vue-next/blob/master/.github/contributing.md) 找到贡献指南。

而贡献指南写了很多关于参与项目开发的信息。比如怎么跑起来，项目目录结构是怎样的。怎么投入开发等。

我们可以在 [项目目录结构](https://github.com/vuejs/vue-next/blob/master/.github/contributing.md#project-structure) 描述中，找到`shared`模块。

`shared`: Internal utilities shared across multiple packages (especially environment-agnostic utils used by both runtime and compiler packages).

`README.md` 和 `contributing.md` 一般都是英文的。可能会难倒一部分人。其实看不懂，完全可以可以借助划词翻译，整页翻译和百度翻译等翻译工具。再把英文加入后续学习计划。

本文就是讲`shared`模块，对应的文件路径是：[`vue-next/packages/shared/src/index.ts`](https://github.com/vuejs/vue-next/blob/master/packages/shared/src/index.ts)

也可以用`github1s`访问，速度更快。[github1s packages/shared/src/index.ts](https://github1s.com/vuejs/vue-next/blob/master/packages/shared/src/index.ts)

为了降低文章难度，我按照贡献指南中方法打包把`ts`转成了`js`。

你需要确保 [Node.js](http://nodejs.org/) 版本是 `10+`, 而且 `yarn` 的版本是 `1.x` [Yarn 1.x](https://yarnpkg.com/en/docs/install)。

```bash
node -v
# v14.16.0
# 全局安装 yarn
# 克隆项目
git clone https://github.com/vuejs/vue-next.git
# 或者克隆我的项目
git clone https://github.com/lxchuan12/vue-next-analysis.git
cd vue-next
npm install --global yarn
yarn # install the dependencies of the project
yarn build
```

可以得到 `vue-next/packages/shared/dist/shared.esm-bundler.js`，文件也就是纯`js`文件。也接下就是解释其中的一些方法。

>当然，前面可能比较啰嗦。我可以直接讲 `3. 工具函数`。但通过我上文的介绍，即使是初学者，都能看懂一些开源项目源码，也许就会有一定的成就感。
>另外，面试问到被类似的问题或者笔试题时，你说看`Vue3`源码学到的，面试官绝对对你刮目相看。

## 3. 工具函数

讲述之前，先推荐我认为不错的`JavaScript API`的几篇文章和几本值得读的书。

[JavaScript 对象所有API解析](https://mp.weixin.qq.com/s/Y3nL3GPcxiqb3zK6pEuycg)

[JavaScript 对象所有API解析](https://lxchuan12.gitee.io/js-object-api/)

[MDN JavaScript](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript)

[《JavaScript高级程序设计》第4版](https://book.douban.com/subject/35175321/)
[《JavaScript 权威指南》第7版](https://book.douban.com/subject/35396470/)
[《你不知道的JavaScript》上中卷](https://book.douban.com/subject/26351021/)

### 3.1 babelParserDefaultPlugins  babel 解析默认插件

```js
/**
 * List of @babel/parser plugins that are used for template expression
 * transforms and SFC script transforms. By default we enable proposals slated
 * for ES2020. This will need to be updated as the spec moves forward.
 * Full list at https://babeljs.io/docs/en/next/babel-parser#plugins
 */
const babelParserDefaultPlugins = [
    'bigInt',
    'optionalChaining',
    'nullishCoalescingOperator'
];
```

### 3.2 EMPTY_OBJ 空对象

```js
const EMPTY_OBJ = (process.env.NODE_ENV !== 'production')
    ? Object.freeze({})
    : {};

// 例子：
// Object.freeze 是 冻结对象
// 冻结的对象最外层无法修改。
const EMPTY_OBJ_1 = Object.freeze({});
EMPTY_OBJ_1.name = '若川';
console.log(EMPTY_OBJ_1.name); // undefined

const EMPTY_OBJ_2 = Object.freeze({ props: { mp: '若川视野' } });
EMPTY_OBJ_2.props.name = '若川';
EMPTY_OBJ_2.props2 = 'props2';
console.log(EMPTY_OBJ_2.props.name); // '若川'
console.log(EMPTY_OBJ_2.props2); // undefined
console.log(EMPTY_OBJ_2);
/**
 * 
 * { 
 *  props: {
     mp: "若川视野",
     name: "若川"
    }
 * }
 * */
```

`process.env.NODE_ENV` 是 `node` 项目中的一个环境变量，一般定义为：`development` 和`production`。根据环境写代码。比如开发环境，有报错等信息，生产环境则不需要这些报错警告。

### 3.3 EMPTY_ARR 空数组

```js
const EMPTY_ARR = (process.env.NODE_ENV !== 'production') ? Object.freeze([]) : [];

// 例子：
EMPTY_ARR.push(1) // 报错，也就是为啥生产环境还是用 []
EMPTY_ARR.length = 3;
console.log(EMPTY_ARR.length); // 0
```

### 3.4 NOOP 空函数

```js
const NOOP = () => { };

// 很多库的源码中都有这样的定义函数
```

### 3.5 NO 永远返回 false 的函数

```js
/**
 * Always return false.
 */
const NO = () => false;
```

### 3.6 isOn 判断字符串是不是 on 开头，并且on后首字母不是小写字母

```js
const onRE = /^on[^a-z]/;
const isOn = (key) => onRE.test(key);

// 例子：
isOn('onChange'); // true
isOn('onchange'); // false
isOn('on3change'); // true
```

### 3.7 isModelListener 监听器

判断字符串是不是以`onUpdate:`开头

```js
const isModelListener = (key) => key.startsWith('onUpdate:');

// 例子：

```

### 3.8 extend 继承 合并

说合并可能更准确些。

```js
const extend = Object.assign;

// 例子：
const data = { name: '若川' };
const data2 = entend(data, { mp: '若川视野', name: '是若川啊' });
console.log(data); // {name: "是若川啊", mp: "若川视野"}
console.log(data2); // {name: "是若川啊", mp: "若川视野"}
console.log(data === data2);
```

### 3.9 remove 移除数组的一项

```js
const remove = (arr, el) => {
    const i = arr.indexOf(el);
    if (i > -1) {
        arr.splice(i, 1);
    }
};

// 例子：
const arr = [1, 2, 3];
remove([1, 2, 3], 3);
console.log(arr); // [1, 2]
```

`splice` 其实是一个很耗性能的方法。删除数组中的一项，其他元素都要移动位置。

**引申**：[`axios InterceptorManager` 拦截器源码](
[axios InterceptorManager](https://github.com/axios/axios/blob/master/lib/core/InterceptorManager.js)
)中，拦截器用数组存储的。但实际移除拦截器时，只是把拦截器置为`null`。而不是用`splice`移除。最后执行时为null的不执行，同样效果。这`axios`拦截器这个场景下，不得不说为性能做到了很好的考虑。

```js
// 代码有删减
// 声明
this.handlers = [];

// 移除
if (this.handlers[id]) {
    this.handlers[id] = null;
}

// 执行
if (h !== null) {
    fn(h);
}
```

### 3.10 hasOwn 是不是自己本身所拥有的属性

```js
const hasOwnProperty = Object.prototype.hasOwnProperty;
const hasOwn = (val, key) => hasOwnProperty.call(val, key);

// 例子：
hasOwn({__proto__: { a: 1 }}, 'a') // false
hasOwn({ a: undefined }, 'a') // true
hasOwn({}, 'a') // false
hasOwn({}, 'hasOwnProperty') // false
hasOwn({}, 'toString') // false
// 是自己的本身拥有的属性，不是通过原型链向上查找的。
```

### 3.11 isArray 判断数组

```js
const isArray = Array.isArray;

isArray([]); // true
const fakeArr = { __proto__: Array.prototype, length: 0 };
isArray(fakeArr); // false
fakeArr instanceof Array; // true
```

### 3.12 isMap 判断是不是 Map 对象

```js
const isMap = (val) => toTypeString(val) === '[object Map]';

// 例子：
```

### 3.13 isSet 判断是不是 Set 对象

```js
const isSet = (val) => toTypeString(val) === '[object Set]';

// 例子：

```

### 3.14 isDate 判断是不是 Date 对象

```js
const isDate = (val) => val instanceof Date;

// 例子：
isDate(new Date()); // true

// `instanceof` 操作符左边是右边的实例。但不是很准，但一般够用了。原理是根据原型链向上查找的。

// 特别提醒：__proto__ 是浏览器实现的原型写法

isDate({__proto__ : new Date()); // true
// 实际上是应该是 Object 才对。
// 所以用 instanceof 判断数组也不准确。
({__proto__: [] }) instanceof Array; // true
// 实际上是对象。
```

判断数组

### 3.15 isFunction 判断是不是函数

```js
const isFunction = (val) => typeof val === 'function';
```

### 3.16 isString 判断是不是字符串

```js
const isString = (val) => typeof val === 'string';
```

### 3.17 isSymbol 判断是不是 Symbol

```js
const isSymbol = (val) => typeof val === 'symbol';
```

### 3.18 isObject 判断是不是对象

```js
const isObject = (val) => val !== null && typeof val === 'object';
```

### 3.19 isPromise 判断是不是 Promise

```js
const isPromise = (val) => {
    return isObject(val) && isFunction(val.then) && isFunction(val.catch);
};
```

### 3.20 objectToString 对象转字符串

```js
const objectToString = Object.prototype.toString;
```

### 3.21 toTypeString  对象转字符串

```js
const toTypeString = (value) => objectToString.call(value);
```

### 3.22 toRawType  对象转字符串 截取后几位

```js
const toRawType = (value) => {
    // extract "RawType" from strings like "[object RawType]"
    return toTypeString(value).slice(8, -1);
};
```

### 3.23 isPlainObject 判断是不是纯粹的对象

```js
const isPlainObject = (val) => toTypeString(val) === '[object Object]';
```

### 3.24 isIntegerKey 判断是不是

```js
const isIntegerKey = (key) => isString(key) &&
    key !== 'NaN' &&
    key[0] !== '-' &&
    '' + parseInt(key, 10) === key;
```

### 3.25 makeMap && isReservedProp

```js
/**
 * Make a map and return a function for checking if a key
 * is in that map.
 * IMPORTANT: all calls of this function must be prefixed with
 * \/\*#\_\_PURE\_\_\*\/
 * So that rollup can tree-shake them if necessary.
 */
function makeMap(str, expectsLowerCase) {
    const map = Object.create(null);
    const list = str.split(',');
    for (let i = 0; i < list.length; i++) {
        map[list[i]] = true;
    }
    return expectsLowerCase ? val => !!map[val.toLowerCase()] : val => !!map[val];
}
const isReservedProp = /*#__PURE__*/ makeMap(
// the leading comma is intentional so empty string "" is also included
',key,ref,' +
    'onVnodeBeforeMount,onVnodeMounted,' +
    'onVnodeBeforeUpdate,onVnodeUpdated,' +
    'onVnodeBeforeUnmount,onVnodeUnmounted');
```

### 3.26 cacheStringFunction 缓存

```js
const cacheStringFunction = (fn) => {
    const cache = Object.create(null);
    return ((str) => {
        const hit = cache[str];
        return hit || (cache[str] = fn(str));
    });
};
const camelizeRE = /-(\w)/g;
/**
 * @private
 */
const camelize = cacheStringFunction((str) => {
    return str.replace(camelizeRE, (_, c) => (c ? c.toUpperCase() : ''));
});
const hyphenateRE = /\B([A-Z])/g;
/**
 * @private
 */
const hyphenate = cacheStringFunction((str) => str.replace(hyphenateRE, '-$1').toLowerCase());
/**
 * @private
 */
const capitalize = cacheStringFunction((str) => str.charAt(0).toUpperCase() + str.slice(1));
/**
 * @private
 */
const toHandlerKey = cacheStringFunction((str) => (str ? `on${capitalize(str)}` : ``));
```

### 3.27 hasChanged 判断是不是有变化

```js
// compare whether a value has changed, accounting for NaN.
const hasChanged = (value, oldValue) => value !== oldValue && (value === value || oldValue === oldValue);
```

### 3.28 invokeArrayFns  执行数组里的函数

```js
const invokeArrayFns = (fns, arg) => {
    for (let i = 0; i < fns.length; i++) {
        fns[i](arg);
    }
};

// 例子：
const arr = [
    function(){
        console.log('我的博客地址是：https://lxchuan12.gitee.io');
    },
    function(val){
        console.log('百度搜索 ' + val + ' 可以找到我');
    },
    function(val){
        console.log('微信搜索 ' + val + '视野 可以找到关注我');
    },
]
invokeArrayFns(arr, '若川');
```

### 3.29 def 定义

```js
const def = (obj, key, value) => {
    Object.defineProperty(obj, key, {
        configurable: true,
        enumerable: false,
        value
    });
};
```

### 3.30 toNumber 转数字

```js
const toNumber = (val) => {
    const n = parseFloat(val);
    return isNaN(n) ? val : n;
};
```

### 3.31 getGlobalThis 全局对象

```js
let _globalThis;
const getGlobalThis = () => {
    return (_globalThis ||
        (_globalThis =
            typeof globalThis !== 'undefined'
                ? globalThis
                : typeof self !== 'undefined'
                    ? self
                    : typeof window !== 'undefined'
                        ? window
                        : typeof global !== 'undefined'
                            ? global
                            : {}));
};
```
