SHOVE_SHELL=
SHOVE_TMPFILE=./.shove.tmp.sh
SHOVE_VERBOSE=
SHOVE_DEBUG=${SHOVE_DEBUG:-}

T_TOTAL=0
T_PASS=0
T_FAIL=0

help() {
  pod2text $0
  exit 1
}

_add() {
  echo "$1" >> $tmp
}

test_file() {
  _t=$1
  tmp=$SHOVE_TMPFILE.${t_cnt}
  dat="${tmp}.dat"

  # create tmp test script
  : > $tmp
  _add ". ${bin_dir}/../lib/t.shrc"
  _add "t_init"
  if [[ $SHOVE_VERBOSE ]]; then
    _add "__t_verbose=1"
  fi
  cat $_t >> $tmp
  _add "echo 1..\$__t_total"
  _add "t_report $dat"

  # exec tmp test script
  echo "$_t ..."
  set +e
  $SHOVE_SHELL $tmp
  ret=$?
  set -e

  data=($(cat $dat))
  T_TOTAL=$((T_TOTAL + ${data[0]}))
  T_PASS=$((T_PASS + ${data[1]}))
  T_FAIL=$((T_FAIL + ${data[2]}))

  if [[ $ret = 0 ]]; then
    echo ok
  else
    printf "\033[0;31mnot ok\033[0;39m\n"
  fi

  rm -f $tmp $dat
}

final_report() {
  cat <<EOS >&1

Test Summary Report
-------------------
EOS
  if [[ $T_FAIL = 0 ]]; then
    printf "\033[0;32mAll tests successful.\033[0;39m\n"
  else
    printf "\033[0;31mSome tests failing.\033[0;39m\n"
  fi

  echo "Files=${t_cnt}, Tests=${T_TOTAL}, Successes=${T_PASS}, Failures=${T_FAIL}"
  if [[ $T_FAIL = 0 ]]; then
    echo "Result: PASS"
    return 0
  else
    echo "Result: FAIL"
    return 1
  fi
}
