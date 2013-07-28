#
# Cookbook Name:: nginx
# Definition:: nginx_site
# Author:: AJ Christensen <aj@junglist.gen.nz>
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define :nginx_site, :enable => true do
  base_file    = "/etc/nginx/sites-available/#{params[:name]}"
  enabled_file = "/etc/nginx/sites-enabled/#{params[:name]}"
  if params[:enable]
    execute "enable nginx site #{params[:name]}" do
      command "ln -s '#{base_file}' '#{enabled_file}'"
      notifies :reload, "service[nginx]", :delayed
      not_if { ::File.symlink?(enabled_file) }
    end
  else
    execute "disable nginx site #{params[:name]}" do
      command "rm -rf '#{enabled_file}'"
      notifies :reload, "service[nginx]", :delayed
      only_if { ::File.symlink?(enabled_file) }
    end
  end
end