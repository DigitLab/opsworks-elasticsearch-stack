template File.join(node[:monit][:conf_dir], "elasticsearch.monitrc") do
  source "elasticsearch.monitrc.erb"
  mode 0440
  owner "root"
  group "root"
end