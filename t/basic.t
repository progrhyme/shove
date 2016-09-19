t_pass
t_ok "foo" "'foo' is, ok."
t_ok "-e ." ". exists"
t_ng "" "blank, is ng."
t_ng "-f ." ". is not file"
t_present "foo bar" "'foo bar' is, ok."
t_blank "" "blank, is blank."
t_is 1 1
t_is a a
t_isnt 1 a "1 isnt a"
t_isnt 1 2
t_isnt "a" "b" "'a' isn't 'b'"
t_success true "true/ succeeds"
t_error false

# vim:set ft=sh :
