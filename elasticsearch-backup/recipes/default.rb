package "jq"

template "/etc/cron.daily/elasticsearch-backup" do
  source "elasticsearch-backup.erb"
  mode "0755"
  owner "root"
  group "root"
end