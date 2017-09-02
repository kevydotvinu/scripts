#!/bin/bash
function find { find $HOME -iname "*.pdf" | \
while read f;
do
  if [[ $f == *.pdf ]]; then
  mkdir -p $HOME/pdf
  cp -f "$f" $HOME/pdf
  fi
done
}
