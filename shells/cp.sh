#!/bin/bash

function _info(){
    echo -e "\033[32m$1\033[0m"
}

function _warning(){
    echo -e "\033[33m$1\033[0m"
}

function _error(){
    echo -e "\033[31m$1\033[0m"
}

function _green(){
	echo "\033[32m"$1"\033[0m"
}

function _cyan(){
	echo "\033[36m"$1"\033[0m"
}

function _blue(){
	echo "\033[34m"$1"\033[0m"
}

function _magenta(){
	echo "\033[35m"$1"\033[0m"
}

function _grey(){
	echo "\033[37m"$1"\033[0m"
}

function _yellow(){
	echo "\033[33m"$1"\033[0m"
}

function _red(){
	echo "\033[31m"$1"\033[0m"
}

# 确保脚本抛出遇到的错误
set -e

_info '
-------------------------------------
把当前项目拷贝到 blog 同步脚本
-------------------------------------
'

cd ../blog/
# git
git pull
git status

cd ../vue-next-analysis

rsync -av --exclude .git/ \
--exclude .vscode/ \
--exclude vue-next/ \
--exclude shells/ \
md/devtools/* \
../blog/docs/vue-devtools-install \

rsync -av --exclude .git/ \
--exclude .vscode/ \
--exclude vue-next/ \
--exclude shells/ \
md/utils/* \
../blog/docs/vue-next-utils \

rsync -av --exclude .git/ \
--exclude .vscode/ \
--exclude vue-next/ \
--exclude shells/ \
md/release/* \
../blog/docs/vue-next-release \

echo

cd ../blog/

# git
git pull
git status
git add docs/vue-devtools-install
git commit -m "feat: docs/vue-devtools-install 同步于 vue-next-analysis/md/devtools :construction:"
git add docs/vue-next-utils
git commit -m "feat: docs/vue-next-utils 同步于 vue-next-analysis/md/utils :construction:"
git add docs/vue-next-release
git commit -m "feat: docs/vue-next-release 同步于 vue-next-analysis/md/release :construction:"
git push


echo

_info '
-------------------------------------
同步完成，并提交到远程仓库
-------------------------------------
'
cd -
