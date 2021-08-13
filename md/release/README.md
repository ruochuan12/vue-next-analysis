# 尤雨溪是怎么发布 vuejs 的

## 1. 前言

最近尤雨溪发布了3.2版本。小版本已经是3.2.2。本文来学习下尤大是怎么发布`vuejs`的。

阅读本文，你将学到：

```bash
1. 熟悉 vuejs 发布流程
2. 动手优化公司项目发布流程
```


发布

### 1.1 
### 1.2 

## 2 环境准备

你需要确保 [Node.js](http://nodejs.org/) 版本是 `10+`, 而且 `yarn` 的版本是 `1.x` [Yarn 1.x](https://yarnpkg.com/en/docs/install)。

你安装的 `Node.js` 版本很可能是低于 `10`。最简单的办法就是去官网重新安装。也可以使用 `nvm`等管理`Node.js`版本。

```bash
node -v
# v14.16.0
# 全局安装 yarn
# 克隆项目
git clone https://github.com/vuejs/vue-next.git
cd vue-next

# 或者克隆我的项目
git clone https://github.com/lxchuan12/vue-next-analysis.git
cd vue-next-analysis

npm install --global yarn
yarn # install the dependencies of the project
# yarn —ignore-scripts 忽略一些安装，更快速
yarn release
```


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


### 2.1 流程梳理

```js
// 前面一堆依赖引入和函数定义等
async function main(){
    // run tests before release
    step('\nRunning tests...')
    // update all package versions and inter-dependencies
  step('\nUpdating cross dependencies...')
  // build all packages with types
  step('\nBuilding all packages...')

  // generate changelog

  step('\nCommitting changes...')

  // publish packages
  step('\nPublishing packages...')

  // push to GitHub
  step('\nPushing to GitHub...')
}
main().catch(err => {
  console.error(err)
})
```

### 2.2