package "jq"

template "/usr/cron.daily/elasticsearch-backup" do
  source "elasticsearch-backup.erb"
  mode "0755"
  owner "root"
  group "root"
end