t_ok ok
(
  t_substart "child group"
  t_ok c1
  (
    t_substart "grand child"
    t_ok gc1
    t_report > /dev/null
  )
  t_subend "grand child"
  t_report > /dev/null
)
t_subend "child group"
