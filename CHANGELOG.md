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

- Quote argument string for compatiability.

## 0.5.0 (2016/4/21)

Initial release.
