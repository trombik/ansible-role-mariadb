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
---
- hosts: localhost
  roles:
    - role: trombik.redhat_repo
      when: ansible_os_family == 'RedHat'
    - role: ansible-role-mariadb
  vars:
    os_mariadb_flags:
      FreeBSD: ""
      Debian: |
        [Service]
      RedHat: ""
    mariadb_flags: "{{ os_mariadb_flags[ansible_os_family] }}"
    os_project_socket:
      FreeBSD: /tmp/mysql.sock
      Debian: /var/run/mysqld/mysqld.sock
      RedHat: /var/lib/mysql/mysql.sock
    project_socket: "{{ os_project_socket[ansible_os_family] }}"

    os_project_basedir:
      FreeBSD: /usr/local
      Debian: /usr
      RedHat: ""
    project_basedir: "{{ os_project_basedir[ansible_os_family] }}"

    os_mariadb_log_dir:
      FreeBSD: "{{ __mariadb_log_dir }}"
      Debian: "{{ __mariadb_log_dir }}"
      RedHat: /var/log/mysqld
    mariadb_log_dir: "{{ os_mariadb_log_dir[ansible_os_family] }}"

    os_mariadb_log_file:
      FreeBSD: "{{ __mariadb_log_file }}"
      Debian: "{{ __mariadb_log_file }}"
      RedHat: "{{ mariadb_log_dir }}/mariadb.log"
    mariadb_log_file: "{{ os_mariadb_log_file[ansible_os_family] }}"

    os_mariadb_config:
      FreeBSD: |
        [client]
        port                            = {{ mariadb_port }}
        socket                          = {{ project_socket }}

        [mysql]
        prompt                          = \u@\h [\d]>\_
        no_auto_rehash

        [mysqld]
        user                            = {{ mariadb_user }}
        port                            = {{ mariadb_port }}
        socket                          = {{ project_socket }}
        bind-address                    = {{ mariadb_host }}
        basedir                         = {{ project_basedir }}
        datadir                         = {{ mariadb_db_dir }}
        log_error                       = {{ mariadb_log_dir }}/error.log
        # tmpdir                          = /var/db/mysql_tmpdir
        # slave-load-tmpdir               = /var/db/mysql_tmpdir
        # secure-file-priv                = /var/db/mysql_secure
        log-bin                         = mysql-bin
        log-output                      = TABLE
        # master-info-repository          = TABLE
        # relay-log-info-repository       = TABLE
        relay-log-recovery              = 1
        slow-query-log                  = 1
        server-id                       = 1
        sync_binlog                     = 1
        sync_relay_log                  = 1
        binlog_cache_size               = 16M
        expire_logs_days                = 30
        # default_password_lifetime       = 0
        # enforce-gtid-consistency        = 1
        # gtid-mode                       = ON
        safe-user-create                = 1
        lower_case_table_names          = 1
        explicit-defaults-for-timestamp = 1
        myisam-recover-options          = BACKUP,FORCE
        open_files_limit                = 32768
        table_open_cache                = 16384
        table_definition_cache          = 8192
        net_retry_count                 = 16384
        key_buffer_size                 = 256M
        max_allowed_packet              = 64M
        query_cache_type                = 0
        query_cache_size                = 0
        long_query_time                 = 0.5

        # use 1M in innodb_buffer_pool_size, instead of 1G
        innodb_buffer_pool_size         = 1M
        innodb_data_home_dir            = {{ mariadb_db_dir }}
        innodb_log_group_home_dir       = {{ mariadb_db_dir }}
        innodb_data_file_path           = ibdata1:128M:autoextend
        # innodb_temp_data_file_path      = ibtmp1:128M:autoextend
        innodb_flush_method             = O_DIRECT
        innodb_log_file_size            = 256M
        innodb_log_buffer_size          = 16M
        innodb_write_io_threads         = 8
        innodb_read_io_threads          = 8
        innodb_autoinc_lock_mode        = 2
        skip-symbolic-links

        [mysqldump]
        max_allowed_packet              = 256M
        quote_names
        quick
      Debian: |
        [client]
        default-character-set = utf8mb4
        socket = {{ project_socket }}
        [client-mariadb]
        [mysql]
        default-character-set = utf8mb4
        [mysql_upgrade]
        [mysqladmin]
        [mysqlbinlog]
        [mysqlcheck]
        [mysqldump]
        [mysqlimport]
        [mysqlshow]
        [mysqlslap]
        [mysqld_safe]
        socket		= {{ project_socket }}
        nice		= 0
        skip_log_error
        syslog
        [server]
        [mysqld]
        user		= mysql
        pid-file	= /var/run/mysqld/mysqld.pid
        socket		= {{ project_socket }}
        port		= {{ mariadb_port }}
        basedir		= /usr
        datadir		= /var/lib/mysql
        tmpdir		= /tmp
        lc-messages-dir	= /usr/share/mysql
        skip-external-locking
        bind-address		= {{ mariadb_host }}
        key_buffer_size		= 16M
        max_allowed_packet	= 16M
        thread_stack		= 192K
        thread_cache_size       = 8
        myisam_recover_options  = BACKUP
        query_cache_limit	= 1M
        query_cache_size        = 16M
        log_error = {{ mariadb_log_file }}
        expire_logs_days	= 10
        max_binlog_size   = 100M
        character-set-server  = utf8mb4
        collation-server      = utf8mb4_general_ci
        [embedded]
        [mariadb]
        [mariadb-10.1]
      RedHat: |
        [mysqld]
        port={{ mariadb_port }}
        bind-address={{ mariadb_host }}
        datadir={{ mariadb_db_dir }}
        socket={{ project_socket }}
        symbolic-links=0
        log-error={{ mariadb_log_file }}
        [mysqld_safe]
        port={{ mariadb_port }}
        bind-address={{ mariadb_host }}
        log-error={{ mariadb_log_dir }}/mariadb.log
        pid-file=/var/run/mariadb/mariadb.pid

    mariadb_config: "{{ os_mariadb_config[ansible_os_family] }}"

    mariadb_root_password: PassWord
    mariadb_root_conf:
      name: root
      content: |
        [client]
        user = "root"
        password = "{{ mariadb_root_password }}"
    mariadb_users:
      - name: foo
        password: PassWord
        # XXX on Ubuntu, the default authentication for `root` user is
        # unix_socket.
        # SELECT user,authentication_string,plugin,host FROM mysql.user;
        # +------+-----------------------+-------------+-----------+
        # | user | authentication_string | plugin      | host      |
        # +------+-----------------------+-------------+-----------+
        # | root |                       | unix_socket | localhost |
        #
        # see https://mariadb.com/kb/en/authentication-from-mariadb-104/

        login_unix_socket: "{% if ansible_os_family == 'Debian' %}{{ project_socket }}{% else %}{{ omit }}{% endif %}"
    mariadb_my_cnf_files:
      - user: vagrant
        path: /home/vagrant/.my.cnf
        content: |
          [client]
          password = "PassWord"

    redhat_repo_extra_packages:
      - epel-release
    redhat_repo:
      epel:
        mirrorlist: "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-{{ ansible_distribution_major_version }}&arch={{ ansible_architecture }}"
        gpgcheck: yes
        enabled: yes
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
