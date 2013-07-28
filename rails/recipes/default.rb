include_recipe "nginx"
include_recipe "unicorn"

gem_package "bundler"

common = {:name => "varun", :app_root => "/u/apps/varun"}

directory common[:app_root] do
  owner "vagrant"
end

directory common[:app_root]+"/current" do
  owner "vagrant"
end

%w(config log tmp sockets pids).each do |dir|
  directory "#{common[:app_root]}/shared/#{dir}" do
    recursive true
    mode 0755
  end
end

template "#{node[:unicorn][:config_path]}/#{common[:name]}.conf.rb" do
  mode 0644
  source "unicorn.conf.erb"
  variables common
end

nginx_config_path = "/etc/nginx/sites-available/#{common[:name]}.conf"

template nginx_config_path do
  mode 0644
  source "nginx.conf.erb"
  variables common.merge(:server_names => "varun.test")
  notifies :reload, "service[nginx]"
end

nginx_site "varun" do
  config_path nginx_config_path
  action :enable
end