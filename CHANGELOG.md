## 0.8.2 (2016/9/25)

Improve:

- Fix problem of `readlink` to work with relative or nested links #9

## 0.8.1 (2016/9/19)

Feature:

- Add new grouping syntax `t::group "$msg" ({ ... })` which is compatible with
the old one `T_SUB ((...))` #6

Deprecate:

- To use the old grouping syntax `T_SUB "$msg" (( ... ))` is now deprecated

## 0.8.0 (2016/9/19)

Feature:

- New testing functions #5
  - String: `t_present`, `t_blank`
  - File/directory: `t_exist`, `t_file`, `t_directory`, `t_symlink`
  - Algebraic: `t_eq`, `t_ne`, `t_gt`, `t_ge`, `t_lt`, `t_le`

Bug Fix:

- `t_is`, `t_isnt`: Add quote to arguments for separated strings #5

## 0.7.4 (2016/9/18)

Enhance:

- Support symlink for `bin/shove` by fetching its path using readlink #4

Internal Change:

- Move `lib/t.shrc` to `lib/shove/t.shrc` #4

Change for Dependency:

- Support new format of `clam.spec` for [clenv](https://github.com/key-amb/clenv)
v0.3 #4

## 0.7.3 (2016/8/28)

Improve:

- Check target file existence of `shove` command #3 BABAROT

## 0.7.2 (2016/5/4)

Internal Change:

- Add test task by [shpec](https://github.com/rylnd/shpec)
- Remove unused variable to get running SHELL

## 0.7.1 (2016/4/26)

Minor Improve:

- Add indent to temporary test scripts according to grouping of tests.

Minor Bug Fix:

- Fix format option of `date` command to make temporary test scripts by minutes.

## 0.7.0 (2016/4/23)

Feature:

- Introduce special syntax `T_SUB <name> (( ... ))` for grouping tests to reduce
  verbose writings and to make test codes more readable.

## 0.6.1 (2016/4/23)

Feature:

- Keep temporary test scripts for a while under working directory for troubleshooting.

## 0.6.0 (2016/4/22)

Improve:

- Add _ksh_ to test targets.
- Don't use `local` keyword for variable declaration because it's not POSIX and
  not supported in _ksh_.

## 0.5.2 (2016/4/22)

Change:

- `shove` now exits 1 when test fails.

Tiny Bug Fix:

- "dash" was taken as "sh" at `t_init()`. (But no test uses the shell variable.)

## 0.5.1 (2016/4/22)

Improve:

- Quote argument string for compatibility.

## 0.5.0 (2016/4/21)

Initial release.
