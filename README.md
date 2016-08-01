[![Build Status](https://travis-ci.org/key-amb/shove.svg?branch=master)](https://travis-ci.org/key-amb/shove)
# shove

A test tool for shell scripts with [TAP](https://testanything.org/) outputs.

The name **"shove"** comes from _"shell"_ and
_"[prove](http://perldoc.perl.org/prove.html)"_ of Perl.

### Table of Contents

* [Screenshots](#screenshots)
* [Supported Shells](#supported-shells)
* [Install](#install)
* [Usage](#usage)
  * [Options](#options)
* [How to write test codes](#how-to-write-test-codes)
  * [Basics](#basics)
  * [Grouping](#grouping)
* [Authors](#authors)
* [License](#license)

# Screenshots

Pass:

<div align="center">
<img src="https://raw.githubusercontent.com/key-amb/shove/resource/image/screenshot-pass_01.png" alt="shove-screenshot-pass_01">
</div>

Fail:

<div align="center">
<img src="https://raw.githubusercontent.com/key-amb/shove/resource/image/screenshot-fail_01.png" alt="shove-screenshot-fail_01">
</div>

# Supported Shells

- _sh, bash, dash, ksh, zsh_

_ash_ is not tested, but hopefully supposed to work with **shove**.  

No plan to support _(t)csh_ or _fish_ because they are not POSIX compatible.

# Install

Just clone this repository or get tarballs from [releases](https://github.com/key-amb/shove/releases) page.

```
# example snippet to install `shove`
mkdir ~/src
git clone https://github.com/key-amb/shove.git ~/src/shove
alias shove="$HOME/src/shove/bin/shove"
shove -V
```

You can make a symlink of `bin/shove` in your favorite path;
i.e. `/usr/local/bin/` or `$HOME/bin/` or any path.  
Or you can make an alias command like the snippet above.

NOTE:  
Do not change the directory structure because `bin/shove` assumes
its libraries exists in `../lib/` directory.

# Usage

```sh
shove TARGETS [OPTIONS]
shove t/foo.t
shove t/foo.t t/bar.t -s /bin/bash -v
shove -r t/ -v

# help
shove -h|--help

# version
shove -V|--version
```

## Options

* `-s|--shell SHELL` : SHELL to execute tests. Default is `$SHELL`.
* `-v|--verbose` : verbose output.

# How to write test codes

Many test functions get hints from
[Test::More](http://perldoc.perl.org/Test/More.html) of Perl.

There are some example test codes in [example](example) directory.

## Basics

```sh
t_ok   $true   "var true is ok"  # [   $true  ]
t_ng   $false  "var false is ng" # [ ! $false ]
t_is   $a $b   "a is b"          # [ "$a"  = "$b" ]
t_isnt $a $b   "a isn't b"       # [ "$a" != "$b" ]
t_success $cmd "cmd succeeds"    # $cmd; [ $? -eq 0 ]
t_error   $cmd "cmd fails"       # $cmd; [ $? -ne 0 ]
```

## Grouping

This feature works like `subtest` of
[Test::More](http://perldoc.perl.org/Test/More.html).

**New special syntax is introduced in v0.7.0:**

```sh
t_ok $ok

T_SUB "level1 group" ((
  t_ok $lv1_ok

  T_SUB "level2 group" ((
    t_ok $lv2_ok
    t_is $lv2_a $lv2_b
  ))
))
```

The codes above is the same as following codes:

```sh
t_ok $ok
(
  t_substart "level1 group"
  t_ok $lv1_ok
  (
    t_substart "level2 group"
    t_ok $lv2_ok
    t_is $lv2_a $lv2_b
    t_subclose
  )
  t_subend "level2 group"
  t_subclose
)
t_subend "level1 group"
```

Tests in group are run in subshell.
So you can run them in different context from main tests context.

If you want test groups A and B not affect to each other, you have to put them in
different groups.

# Authors

YASUTAKE Kiyoshi <yasutake.kiyoshi@gmail.com>

# License

The MIT License (MIT)

Copyright (c) 2016 YASUTAKE Kiyoshi
