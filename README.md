# trombik.mariadb

`ansible` role for `maraidb` and `mysql`.

## Note for CentOS users

When using MySQL 8.0, idempotency test fails due to a bug in `mysql_user`
`ansible` module.

Due to a bug in pre-start script, you cannot change `mariadb_log_file` when
`mariadb_family` is `mysql`.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `mariadb_user` | user name of `mariadb` | `{{ __mariadb_user }}` |
| `mariadb_group` | group name of `mariadb` | `{{ __mariadb_group }}` |
| `mariadb_log_dir` | path to base directory of log file | `{{ __mariadb_log_dir }}` |
| `mariadb_log_file` | path to log file | `{{ __mariadb_log_file }}` |
| `mariadb_db_dir` | path to `datadir` | `{{ __mariadb_db_dir }}` |
| `mariadb_service` | service name of `mariadb` | `{{ __mariadb_service }}` |
| `mariadb_package` | package name of `mariadb` | `{{ __mariadb_package }}` |
| `mariadb_ansible_packages` | list of require packages for `ansible` | `{{ __mariadb_ansible_packages }}` |
| `mariadb_conf_dir` | path to configuration directory | `{{ __mariadb_conf_dir }}` |
| `mariadb_conf_file` | path to configuration file | `{{ __mariadb_conf_file }}` |
| `mariadb_config` | content of `mariadb_conf_file` | `""` |
| `mariadb_flags` | TBW | `""` |
| `mariadb_port` | port number that can be connected to | `3306` |
| `mariadb_host` | host name that can be connected to | `127.0.0.1` |
| `mariadb_root_password` | the administrator password of `root` user | `""` |
| `mariadb_my_cnf_files` | see below | `[]` |
| `mariadb_family` | either `mariadb` or `mysql` | `{{ __mariadb_family }}` |

## Debian

| Variable | Default |
|----------|---------|
| `__mariadb_user` | `mysql` |
| `__mariadb_group` | `mysql` |
| `__mariadb_log_dir` | `/var/log/mysql` |
| `__mariadb_log_file` | `{{ __mariadb_log_dir }}/error.log` |
| `__mariadb_package` | `mariadb-server` |
| `__mariadb_ansible_packages` | `["python-pymysql"]` |
| `__mariadb_service` | `mariadb` |
| `__mariadb_db_dir` | `/var/lib/mysql` |
| `__mariadb_conf_dir` | `/etc/mysql` |
| `__mariadb_conf_file` | `{{ __mariadb_conf_dir }}/mariadb.cnf` |
| `__mariadb_family` | `mariadb` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__mariadb_user` | `mysql` |
| `__mariadb_group` | `mysql` |
| `__mariadb_log_dir` | `/var/log/mysql` |
| `__mariadb_log_file` | `{{ __mariadb_log_dir }}/error.log` |
| `__mariadb_package` | `databases/mariadb101-server` |
| `__mariadb_ansible_packages` | `["databases/py-pymysql"]` |
| `__mariadb_service` | `mysql-server` |
| `__mariadb_db_dir` | `/var/db/mysql` |
| `__mariadb_conf_dir` | `/usr/local/etc/mysql` |
| `__mariadb_conf_file` | `{{ __mariadb_conf_dir }}/my.cnf` |
| `__mariadb_family` | `mariadb` |

## RedHat

| Variable | Default |
|----------|---------|
| `__mariadb_user` | `mysql` |
| `__mariadb_group` | `mysql` |
| `__mariadb_log_dir` | `/var/log` |
| `__mariadb_log_file` | `{{ __mariadb_log_dir }}/mysqld.log` |
| `__mariadb_package` | `mariadb-server` |
| `__mariadb_ansible_packages` | `["python2-PyMySQL"]` |
| `__mariadb_service` | `mariadb` |
| `__mariadb_db_dir` | `/var/lib/mysql` |
| `__mariadb_conf_dir` | `/etc` |
| `__mariadb_conf_file` | `{{ __mariadb_conf_dir }}/my.cnf` |
| `__mariadb_family` | `mariadb` |

# Dependencies

None

# Example Playbook

```yaml
```

# License

```
Copyright (c) 2020 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
