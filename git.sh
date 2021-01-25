#!/bin/bash

# use: sh ./git.sh "commit内容" || ./git.sh "添加自动提交的使用方式 如果不能执行，先chmod +x  git.sh"
hasGit=`which git`
msg=${1:-'auto commit'}
file=${2}


if [ ! $hasGit ];then
  echo 'git init or git clone url';
  exit 1;
else
  branch=`git branch | grep "*" | tr -d \*`
  #if [ $branch == master ];then
  # exit 1;
  if [ $branch == dev ];then
    # ./git.sh -vm 替换版本号并生成版本内容文件，上传至Dev发起merge到master
    if [ "$msg" = "-vm" ];then
      # echo -n "请输入本次进版需求版本号："

      curBr=`git symbolic-ref --short -q HEAD`
      # line=`grep -n 'version' project.config.json`
      # version=`sed -n '4p' project.config.json | awk '{print $2}' | tr -d \"\,`
      version=`grep -n 'version' utils/config.js | awk '{print $3}' | tr -d \"\,`
      time=$(date "+%Y-%m-%d %H:%M:%S")
      git pull origin master
      echo "本次进版需求版本号：$version" >> versions.txt
      echo "本次进版日期：$time" >> versions.txt
      echo "本次进版需求内容如下：\n`git log --format='%s' master...${curBr}`" >> versions.txt
      echo '\n\n\n' >> versions.txt
      git add . && git commit -m "$msg" && git push origin ${branch:2}
      exit 1;
    fi
    username=`git config user.name`
    random=`openssl rand -base64 5`
    time=$(date "+%Y%m%d-%H%M%S")
    git checkout -b "${username-guest}-${time-$random}"
    git push --set-upstream origin "${username-guest}-${time-$random}"
  fi
  newbranch=`git branch | grep "*" | tr -d \*`
  if [ ! $file ];then
    git add . && git commit -m "$msg" && git push origin ${newbranch}
    exit 1;
  else
    git add ${file} && git commit -m "$msg" && git push origin ${newbranch}
    exit 1;
  fi
fi
