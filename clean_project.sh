#!/usr/bin/env bash

if [[ $# -eq 1 ]] && [[ $1 == "-b" ]]; then
  rm -r admin/ machines/ users/ backup/
else
  rm -r admin/ machines/ users/
fi
