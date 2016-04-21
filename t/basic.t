t_pass
t_ok "foo" "'foo' is, ok."
t_ng "" "blank, is ng."
t_is 1 1
t_is a a
t_isnt 1 a "1 isnt a"
t_isnt 1 2
t_isnt "a" "b" "'a' isn't 'b'"
t_success true "true/ succeeds"
t_error false
