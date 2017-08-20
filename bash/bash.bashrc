#!/bin/bash
if [[ -n "${BASH_SOURCE[0]}" ]]; then
  CURRENTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
  CURRENTDIR="$(dirname "$(which "$0")")"
fi

for f in $CURRENTDIR/*.sh;
do
  source $f
done

