execute "install_plugin_es_aws" do
    user "root"
    cwd "#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/bin/"
    command "plugin -install elasticsearch/elasticsearch-cloud-aws/#{node.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-aws']['version']}"
    not_if { File.exist?("#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/cloud-aws") }
end

execute "install_plugin_es_kopf" do
    user "root"
    cwd "#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/bin/"
    command "plugin -install lmenezes/elasticsearch-kopf"
    not_if { File.exist?("#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/kopf") }
end

#notifies :restart, 'service[elasticsearch]' unless node.elasticsearch[:skip_restart]