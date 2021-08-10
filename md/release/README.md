# 尤雨溪是怎么发布 vuejs 的

## 1. 前言

package.json
script

```json
{
    "private": true,
    "version": "3.2.0-beta.1",
    "workspaces": [
        "packages/*"
    ],
    "scripts": {
        "release": "node scripts/release.js",
    }
}
```

发布

### 1.1 
### 1.2 

## 2 环境准备

### 2.1
### 2.2

```js
// 前面一堆依赖引入和函数定义等
async function main(){

}
main().catch(err => {
  console.error(err)
})
```
