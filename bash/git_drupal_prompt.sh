#!/bin/bash
if [[ -n "${BASH_SOURCE[0]}" ]]; then
  CURRENTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
  CURRENTDIR="$(dirname "$(which "$0")")"
fi

for f in $CURRENTDIR/git_drupal_prompt/*;
do
  source $f
done
PS1="🍺  \u@\h:\033[31m\W\033[0m\033[32m\$(prompt_universal)\033[0m $ "

