#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# 生成静态文件
npm run build

# 进入生成的文件夹
cd docs/.vuepress/dist


# deploy to github pages
#echo 'vicxsl.github.io' > CNAME

if [ -z "$GITHUB_TOKEN" ]; then
  msg='deploy'
  githubUrl=git@github.com:vicxsl/vicxsl.github.io.git
else
  msg='来自github actions的自动部署'
  githubUrl=https://vicxsl:${GITHUB_TOKEN}@github.com/vicxsl/vicxsl.github.io.git
  git config --global user.name "vicxsl"
  git config --global user.email "vicxsl@163.com"
fi
printf "初始化仓库\n"
git init

printf "查看分支和仓库\n"
git branch # 查看当前分支
git status #   查看当前仓库的状态
printf "打印当前目录\n"
ll # 打印当前目录

printf "添加文件\n"
git add -A #  添加所有文件到暂存区

printf "历史提交版本\n"
git log #   查看本地仓库中的历史提交版本

printf "提交\n"
git commit -m "${msg}"

printf "历史提交版本\n"
git log

printf "推送到github\n"
git push -f $githubUrl master:gh-pages # 推送到github gh-pages分支

#deploy to coding pages
# echo 'www.xugaoyi.com\nxugaoyi.com' > CNAME  # 自定义域名
# echo 'google.com, pub-7828333725993554, DIRECT, f08c47fec0942fa0' > ads.txt # 谷歌广告相关文件

if [ -z "$CODING_TOKEN" ]; then # -z 字符串 长度为0则为true；$CODING_TOKEN来自于github仓库`Settings/Secrets`设置的私密环境变量
  codingUrl=git@e.coding.net:vicsl/blog/blog.git
else
  codingUrl=https://vicsl:${CODING_TOKEN}@e.coding.net/vicsl/blog/blog.git
fi
git add -A
git commit -m "${msg}"
git push -f $codingUrl master # 推送到coding

cd -
rm -rf docs/.vuepress/dist
