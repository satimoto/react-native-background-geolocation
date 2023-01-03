#!/bin/sh -e
basedir=$(pwd)
gitmodules="$basedir/.gitmodules"
path=""
url=""

while IFS= read -r line; do
  line=($(echo $line | tr -d " "));

  if [[ $line =~ ^path= ]]; then
    path=($(echo $line | sed -e "s/path=//"));
  elif [[ $line =~ ^url= ]]; then
    url=($(echo $line | sed -e "s/url=//"));

    if [ -d "$path/.git" ] ; then
      cd $path;
      echo "pulling $basedir/$path"
      git pull;
      cd - > /dev/null;
    else
      git clone $url $path;
    fi

    unset path;
    unset url;
  fi
done < $gitmodules;