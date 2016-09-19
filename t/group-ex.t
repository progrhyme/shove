t_ok ok

T_SUB "child group 1" ((
  t_ok c1

  T_SUB "grand child 1" ((
    t_ok gc1
  ))

  t::group "grand child 2" ({
    t_ok gc2
  })
))

t::group "child child 2" ({
  t_ok c2
})

# vim:set ft=sh :
