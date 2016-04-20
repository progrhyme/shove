t_ok ok
t_ng ng
(
  t_substart "start child"
  t_ok c1
  t_ng c2
  t_success foo "command 'foo' fails"
  (
    t_substart "grand child"
    t_ok gc1
    t_ng gc2
    t_subclose
  )
  t_subend "grand child"
  t_subclose
)
t_subend "end child"
