execute "install_plugin_es_aws" do
    user "root"
    cwd "#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/bin/"
    command "plugin -install elasticsearch/elasticsearch-cloud-aws/#{node.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-aws']['version']}"
    not_if { File.exist?("#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/cloud-aws") }
end

execute "install_plugin_es_head" do
    user "root"
    cwd "#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/bin/"
    command "plugin -install mobz/elasticsearch-head"
    not_if { File.exist?("#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/head") }
end

#notifies :restart, 'service[elasticsearch]' unless node.elasticsearch[:skip_restart]