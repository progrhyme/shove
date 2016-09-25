SHOVE_SHELL=
SHOVE_WORKDIR=${SHOVE_WORK_DIR:-"${HOME}/.shove"}
SHOVE_TMPFILE=${SHOVE_WORKDIR}/t_script.$(date +%Y%m%d%H%M).sh
SHOVE_KEEPDAYS=${SHOVE_KEEPDAYS:-3}
SHOVE_VERBOSE=
SHOVE_DEBUG=${SHOVE_DEBUG:-}

T_TOTAL=0
T_PASS=0
T_FAIL=0

LF=$(printf '\\\012_')
LF=${LF%_}

help() {
  pod2text $0
  exit 1
}

# indent
_lv=0
_ws() {
  if [ $_lv -gt 0 ]; then
    printf '%*s' $((_lv * 2))
  fi
}

_add() {
  echo "$(_ws)$1" >> $tmp
}

purge_tmp_files() {
  purge_targets=($(find $SHOVE_WORKDIR -type f -mtime +${SHOVE_KEEPDAYS}))
  if [[ -z "${purge_targets:-}" ]]; then
    return
  fi
  echo -n "# Purge ${#purge_targets[@]} files..."
  for pt in ${purge_targets[@]}; do
    rm -f $pt
  done
  echo "done."
}

test_file() {
  if [[ ! -f $1 ]]; then
    echo "$1: Is not a regular file" >&2
    exit 1
  fi
  _t=$1
  tmp=$SHOVE_TMPFILE.${t_cnt}
  dat="${tmp}.dat"

  ## create tmp test script
  : > $tmp
  _add ". ${lib_dir}/shove/t.shrc"
  _add "t_init"
  if [[ $SHOVE_VERBOSE ]]; then
    _add "__t_verbose=1"
  fi
  cat $_t | while read line; do
    if [[ "$line" =~ ^[[:space:]]*t::group[[:space:]]*.*\(\{$ ]]; then
      #echo "# '$line' matches group beginning."
      _item="$(echo $line | sed -e 's/^t::group //' | sed -e 's/ ({$//')"
      subtests+=("${_item}")
      _add '('
      : $((_lv += 1))
      _add "t_substart ${_item}"
    elif [[ "$line" =~ ^[[:space:]]*T_SUB[[:space:]]*.*\(\($ ]]; then
      #echo "# '$line' matches group beginning."
      _item="$(echo $line | sed -e 's/^T_SUB //' | sed -e 's/ (($//')"
      subtests+=("${_item}")
      _add '('
      : $((_lv += 1))
      _add "t_substart ${_item}"
    elif [[ "$line" =~ ^[[:space:]]*[\}\)]\)$ ]]; then
      #echo "# '$line' matches group ending."
      declare -i num=${#subtests[@]}
      last=$((num - 1))
      _item="${subtests[$last]}"
      subtests=("${subtests[@]:0:$last}")
      echo "$(_ws)t_subclose" >> $tmp
      : $((_lv -= 1))
      _add ')'
      _add "t_subend ${_item}"
    else
      _add "$line"
    fi
  done
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
    rm -f $tmp
  else
    printf "\033[0;31mnot ok\033[0;39m\n"
    cat <<EOS >&1
----
# To reproduce this, run this:
#   $SHOVE_SHELL [-x] $tmp
# Add '-x' to look into it.
EOS
  fi

  rm -f $dat
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
