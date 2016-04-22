t_ok ok
t_ng ng
T_SUB "child group" ((
  t_ok c1
  t_ng c2
  t_success foo "command 'foo' fails"
  T_SUB "grand child" ((
    t_ok gc1
    t_ng gc2
  ))
))
