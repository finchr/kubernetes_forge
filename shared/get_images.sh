#!/bin/bash

for x in $(docker images | grep -v REPOSITORY | awk '{print $1 ":" $2}')
do
  y=${x#*\/}
  echo $x $y
  if [ -f $y.tar.gz ]
  then
    echo "file $y.tar.gz already exists, skipping"
  else
    echo -n "saving $x to  $y.tar.gz ... "
    docker save $x -o $y.tar
    gzip $y.tar
    echo "done"
  fi
done
