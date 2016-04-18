t_pass
t_fail
t_ok "foo"
t_ok "-z 'foo'"
t_ng "-f 'no-such-file'"
t_ng ""
t_is 1 1
t_is 1 2
t_is 1 a
t_isnt 1 a
t_isnt 1 2
t_isnt "a" "a"
t_success true
t_success "echo 'foo'"
t_error false
t_error "echo 'foo' | grep 'bar'"
