t_exist .
t_file $0
t_directory .

T_SUB "Test symlink" ((
  tmpdir=tmp/file-test
  mkdir $tmpdir
  touch $tmpdir/testfile
  ln -s $tmpdir/testfile $tmpdir/testlink
  t_symlink $tmpdir/testlink
  rm -rf $tmpdir
))

# vim:set ft=sh :
