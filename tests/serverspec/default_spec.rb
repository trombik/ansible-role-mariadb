require "spec_helper"
require "serverspec"

package = "mariadb-server"
service = "mariadb"
config_dir = "/etc/mysql"
# user    = "mysql"
# group   = "mysql"
ports = [3306]
# db_dir  = "/var/lib/mysql"

case os[:family]
when "freebsd"
  package = "databases/mariadb101-server"
  service = "mysql-server"
  config_dir = "/usr/local/etc/mysql"
  # db_dir = "/var/db/mysql"
when "redhat"
  config_dir = "/etc"
end
config = "#{config_dir}/my.cnf"

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("Managed by ansible") }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/#{service.tr('-', '_')}") do
    it { should be_file }
    its(:content) { should match Regexp.escape("Managed by ansible") }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe file "/root/.my.cnf" do
  it { should exist }
  it { should be_file }
  it { should be_owned_by "root" }
  it { should be_mode 600 }
  its(:content) { should match(/Managed by ansible/) }
  its(:content) { should match(/^password = "PassWord"/) }
end

describe file "/root/.mysql_secret" do
  it { should_not exist }
end

describe command "env MYSQL_PWD=PassWord mysql -uroot -e 'SHOW DATABASES'" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^|\s+mysql\s+\|$/) }
end

describe file "/home/vagrant/.my.cnf" do
  it { should exist }
  it { should be_file }
  it { should be_owned_by "vagrant" }
  it { should be_mode 600 }
  its(:content) { should match(/Managed by ansible/) }
  its(:content) { should match(/^password = "PassWord"/) }
end
