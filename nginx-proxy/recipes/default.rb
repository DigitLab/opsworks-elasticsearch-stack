include_recipe "nginx"

directory node["nginx-proxy"][:htpasswd_dir] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

node["nginx-proxy"][:sites].each do |application_name, application|

  nginx_conf = "#{node[:nginx][:dir]}/sites-available/#{application_name}"
  htpasswd_file = "#{node["nginx-proxy"][:htpasswd_dir]}/#{application_name}.htpasswd"

  template nginx_conf do
    Chef::Log.debug("Generating Nginx site template for #{application_name.inspect}")
    source "site.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :application => application,
      :application_name => application_name,
      :htpasswd_file => htpasswd_file
    )
    if File.exists?("#{node[:nginx][:dir]}/sites-enabled/#{application_name}")
      notifies :reload, "service[nginx]", :delayed
    end
  end

  ruby_block "add users to passwords file" do
    block do
      require 'webrick/httpauth/htpasswd'
      @htpasswd = WEBrick::HTTPAuth::Htpasswd.new("#{htpasswd_file}")

      application[:users].each do |u|
        Chef::Log.debug "Adding user '#{u['username']}' to #{htpasswd_file}\n"
        @htpasswd.set_passwd( 'Elasticsearch', u['username'], u['password'] )
      end

      @htpasswd.flush
    end

    not_if { application[:users].empty? }
  end

  file "#{htpasswd_file}" do
    owner "root" and group "root" and mode 0644
    action :touch
  end

  execute "nxensite #{application_name}" do
    command "/usr/sbin/nxensite #{application_name}"
    notifies :reload, "service[nginx]"
    not_if do File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{application_name}") end
  end

end