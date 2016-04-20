SHOVE_SHELL=
SHOVE_TMPFILE=./.shove.tmp.sh
SHOVE_VERBOSE=
SHOVE_DEBUG=${SHOVE_DEBUG:-}

help() {
  pod2text $0
  exit 1
}

_add() {
  echo "$1" >> $tmp
}

test_file() {
  _t=$1
  tmp=$SHOVE_TMPFILE.$i

  # create tmp test script
  : > $tmp
  _add ". ${bin_dir}/../lib/t.shrc"
  _add "t_init"
  if [[ $SHOVE_VERBOSE ]]; then
    _add "__t_verbose=1"
  fi
  cat $_t >> $tmp
  _add "t_report"

  # exec tmp test script
  echo "# $_t by $SHOVE_SHELL"
  set +e
  $SHOVE_SHELL $tmp
  result=$?
  set -e

  if [[ $result = 0 ]]; then
    printf "\033[0;32mTests for $_t - PASS.\033[0;39m\n"
  else
    printf "\033[0;31mTests for $_t - FAIL.\033[0;39m\n"
  fi

  rm -f $tmp
}
