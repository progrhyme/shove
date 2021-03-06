# zsh

__t_idx=1
__t_total=0
__t_ok=0
__t_ng=0
__t_level=0
__t_verbose=""
__t_tmpfile="./.__t_tmp.dat"

_t_incr() {
  _var=$1
  _cur_var=$(($_var))
  eval ": $(($_var += 1))"
  unset _var _cur_var
}

_t_either() {
  _t_result=$1
  _t_incr __t_idx
  _t_incr __t_total
  _t_incr $_t_result
  unset _t_result
}

_t_incr_level() {
  : $((__t_level += 1))
}

_t_decr_level() {
  : $((__t_level -= 1))
}

_t_put() {
  if [ $__t_level -gt 0 -a -z "$__t_verbose" ]; then
    return
  fi
  if [ $__t_level -gt 0 ]; then
    printf '%*s' $((__t_level * 2))
  fi
  printf "$1\n"
}

t_init() {
  __t_idx=1
  __t_total=0
  __t_ok=0
  __t_ng=0
}

t_diag() {
  _t_put "# $1"
}

t_pass() {
  if [ "$__t_verbose" ]; then
    _t_put "ok $__t_idx - ${1:-pass}"
  fi
  _t_either __t_ok
  return 0
}

t_fail() {
  _t_put "\033[0;31mnot ok $__t_idx - ${1:-fail}\033[0;39m"
  _t_either __t_ng
  return 1
}

_t_pass_or_fail() {
  _sbj="$1"
  _diag="$2"
  if eval "$_sbj"; then
    t_pass "$2"
  else
    t_fail "$2"
  fi
}

_t_single() {
  _sbj="$1"
  _diag="${2:-}"
  _type=$3
  if [ -z "$_diag" ]; then
    case "$_type" in
      "ok"        ) _diag="ok $_sbj";;
      "ng"        ) _diag="ng $_sbj";;
      "present"   ) _diag="$_sbj is present";;
      "blank"     ) _diag="$_sbj is blank";;
      "exist"     ) _diag="$_sbj exists";;
      "file"      ) _diag="$_sbj is file";;
      "directory" ) _diag="$_sbj is directory";;
      "symlink"   ) _diag="$_sbj is symlink";;
      * ) echo "Unknown type: ${_type}" >&2; exit 1;;
    esac
  fi

  case "$_type" in
    "ok"        ) _t_pass_or_fail "[ $_sbj ]" "$_diag" ;;
    "ng"        ) _t_pass_or_fail "[ ! $_sbj ]" "$_diag" ;;
    "present"   ) _t_pass_or_fail "[ -n '$_sbj' ]" "$_diag" ;;
    "blank"     ) _t_pass_or_fail "[ -z '$_sbj' ]" "$_diag" ;;
    "exist"     ) _t_pass_or_fail "[ -e '$_sbj' ]" "$_diag" ;;
    "file"      ) _t_pass_or_fail "[ -f '$_sbj' ]" "$_diag" ;;
    "directory" ) _t_pass_or_fail "[ -d '$_sbj' ]" "$_diag" ;;
    "symlink"   ) _t_pass_or_fail "[ -L '$_sbj' ]" "$_diag" ;;
    * ) echo "Unknown type: ${_type}" >&2; exit 1;;
  esac
  unset _sbj _diag _type
}

t_ok() {
  _t_single "$1" "${2:-}" ok
}

t_ng() {
  _t_single "$1" "${2:-}" ng
}

t_present() {
  _t_single "$1" "${2:-}" present
}

t_blank() {
  _t_single "$1" "${2:-}" blank
}

t_exist() {
  _t_single "$1" "${2:-}" exist
}

t_file() {
  _t_single "$1" "${2:-}" file
}

t_directory() {
  _t_single "$1" "${2:-}" directory
}

t_symlink() {
  _t_single "$1" "${2:-}" symlink
}

_t_pair() {
  _lhs="$1"
  _rhs="$2"
  _diag="${3:-}"
  _type=$4
  if [ -z "$_diag" ]; then
    case "$_type" in
      "is"   ) _diag="$_lhs is $_rhs";;
      "isnt" ) _diag="$_lhs isn't $_rhs";;
      "eq"   ) _diag="$_lhs == $_rhs";;
      "ne"   ) _diag="$_lhs != $_rhs";;
      "gt"   ) _diag="$_lhs > $_rhs";;
      "ge"   ) _diag="$_lhs >= $_rhs";;
      "lt"   ) _diag="$_lhs < $_rhs";;
      "le"   ) _diag="$_lhs <= $_rhs";;
      * ) echo "Unknown type: ${_type}" >&2; exit 1;;
    esac
  fi

  case "$_type" in
    "is"   ) _t_pass_or_fail "[ '$_lhs' = '$_rhs' ]" "$_diag" ;;
    "isnt" ) _t_pass_or_fail "[ '$_lhs' != '$_rhs' ]" "$_diag" ;;
    "eq"   ) _t_pass_or_fail "[ $_lhs -eq $_rhs ]" "$_diag" ;;
    "ne"   ) _t_pass_or_fail "[ $_lhs -ne $_rhs ]" "$_diag" ;;
    "gt"   ) _t_pass_or_fail "[ $_lhs -gt $_rhs ]" "$_diag" ;;
    "ge"   ) _t_pass_or_fail "[ $_lhs -ge $_rhs ]" "$_diag" ;;
    "lt"   ) _t_pass_or_fail "[ $_lhs -lt $_rhs ]" "$_diag" ;;
    "le"   ) _t_pass_or_fail "[ $_lhs -le $_rhs ]" "$_diag" ;;
    * ) echo "Unknown type: ${_type}" >&2; exit 1;;
  esac
  unset _lhs _rhs _diag _type
}

t_is() {
  _t_pair "$1" "$2" "${3:-}" is
}

t_isnt() {
  _t_pair "$1" "$2" "${3:-}" isnt
}

t_eq() {
  _t_pair "$1" "$2" "${3:-}" eq
}

t_ne() {
  _t_pair "$1" "$2" "${3:-}" ne
}

t_gt() {
  _t_pair "$1" "$2" "${3:-}" gt
}

t_ge() {
  _t_pair "$1" "$2" "${3:-}" ge
}

t_lt() {
  _t_pair "$1" "$2" "${3:-}" lt
}

t_le() {
  _t_pair "$1" "$2" "${3:-}" le
}

_t_try() {
  local _cmd="$1"
  local _type=$2
  local _diag="$3"
  local _fail=""
  local opt_shwordsplit=$(setopt | grep shwordsplit || true)
  if [[ -z "$opt_shwordsplit" ]]; then
    setopt shwordsplit
  fi
  $_cmd > $__t_tmpfile 2>&1
  local _ret=$?
  if [[ -z "$opt_shwordsplit" ]]; then
    unsetopt shwordsplit
  fi
  if [ "$_type" = "success" ]; then
    if [ $_ret -ne 0 ]; then
      _fail=1
    fi
  elif [ $_ret -eq 0 ]; then
    _fail=1
  fi
  if [ "$_fail" ]; then
    t_fail "$_diag"
    cat $__t_tmpfile | while read _t_line; do
      _t_put "\033[0;31m# ${_t_line}\033[0;39m"
    done
  else
    t_pass "$_diag"
  fi
  rm -f $__t_tmpfile
}

t_success() {
  _cmd="$1"
  _diag="${2:-}"
  if [ -z "$_diag" ]; then
    _diag="$1 success"
  fi
  _t_try "$_cmd" "success" "$_diag"
  unset _cmd _diag
}

t_error() {
  _cmd="$1"
  _diag="${2:-}"
  if [ -z "$_diag" ]; then
    _diag="$1 error"
  fi
  _t_try "$_cmd" "error" "$_diag"
  unset _cmd _diag
}

t_substart() {
  t_init
  _t_incr_level
  t_diag "${1:-substart}"
}

t_subend() {
  t_is $? 0 "${1:-subend}"
}

t_subclose() {
  _t_put "1..$__t_total"
  t_report
}

t_report() {
  if [ "${1:-}" ]; then
    printf "$__t_total\t$__t_ok\t$__t_ng\n" > $1
  fi
  return $__t_ng
}
