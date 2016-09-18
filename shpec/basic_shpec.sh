. lib/shove/t.shrc

test_equal() {
  sbj="$1"
  it "$sbj = $2"
    _sbj=$(($sbj))
    assert equal $_sbj $2
  end
  unset sbj
}

should_pass() {
  it "$1"
    assert equal $__t_ok 1
    assert equal $__t_ng 0
  end
}

should_fail() {
  it "$1"
    assert equal $__t_ok 0
    assert equal $__t_ng 1
  end
}

describe "t_init"
  t_init
  test_equal __t_idx 1
  for var in total ok ng level; do
    test_equal __t_${var} 0
  done
  unset var
end

describe "t_pass"
  t_init
  t_pass
  test_equal __t_idx 2
  test_equal __t_total 1
  test_equal __t_ok 1
  test_equal __t_ng 0
end

describe "t_fail"
  t_init
  t_fail >/dev/null
  test_equal __t_idx 2
  test_equal __t_total 1
  test_equal __t_ok 0
  test_equal __t_ng 1
end

describe "t_ok"
  t_init
  t_ok "ok"
  should_pass "ok is ok"
  t_init
  t_ok "" >/dev/null 2>&1
  should_fail "<blank> is not ok"
end

describe "t_ng"
  t_init
  t_ng "ng" >/dev/null 2>&1
  should_fail "ng is not ng"
  t_init
  t_ng ""
  should_pass "<blank> is ng"
end

describe "t_is"
  t_init
  t_is 1 1
  should_pass "1 is 1"
  t_init
  t_is "aaa" "aaa"
  should_pass "aaa is aaa"
  t_init
  t_is 1 0 >/dev/null 2>&1
  should_fail "1 is not 0"
  t_init
  t_is "aaa" "aab" >/dev/null 2>&1
  should_fail "aaa is not aab"
end

describe "t_isnt"
  t_init
  t_isnt 1 1 >/dev/null 2>&1
  should_fail "1 is 1"
  t_init
  t_isnt "aaa" "aaa" >/dev/null 2>&1
  should_fail "aaa is aaa"
  t_init
  t_isnt 1 0
  should_pass "1 isn't 0"
  t_init
  t_isnt "aaa" "aab"
  should_pass "aaa isn't aab"
end

describe "t_success"
  t_init
  t_success true
  should_pass "true succeeds"
  t_init
  t_success false >/dev/null 2>&1
  should_fail "false fails"
end

describe "t_error"
  t_init
  t_error true >/dev/null 2>&1
  should_fail "true doesn't fail"
  t_init
  t_error false
  should_pass "false fails"
end
