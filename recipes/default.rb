#
# Cookbook:: apex_cookbook
# Recipe:: default
#
# Copyright:: 2017, dataday, All Rights Reserved.
#
# Description
# Default recipe used within the project

apex = node[:apex_cookbook]
name = apex[:name]

download_url = apex[:download] % [
  get_version(apex),
  get_release(apex)
]

bin_path = File.join apex[:bin]
bin_file = File.join apex[:bin], name
etc_file = File.join apex[:etc], "#{name}.sh"
tmp_file = File.join apex[:tmp], name

# create bin path
directory 'create bin path' do
  path bin_path
  action :nothing
  recursive true
  owner apex[:owner]
  group apex[:group]
  mode  apex[:mode]
end

# create bin file
execute 'create bin file' do
  cwd bin_path
  action :nothing
  command "cp --preserve #{tmp_file} #{bin_file}"
  only_if { File.exist? tmp_file }
end

# create etc file
template 'create etc file' do
  path etc_file
  action :nothing
  source 'etc.erb'
  owner apex[:owner]
  group apex[:group]
  mode  apex[:mode]
  helper(:bin_path) { bin_path }
  only_if { File.exist? bin_file }
end

# delete tmp file
file 'delete tmp file' do
  path tmp_file
  action :nothing
  only_if { File.exist? tmp_file }
end

# create tmp file
remote_file 'create tmp file' do
  path tmp_file
  source download_url
  owner apex[:owner]
  group apex[:group]
  mode  apex[:mode]

  # action: create bin path
  notifies :create, 'directory[create bin path]', :immediately
  # action: create bin file
  notifies :run, 'execute[create bin file]', :immediately
  # action: create etc file
  notifies :create, 'template[create etc file]', :immediately
  # action: delete tmp file
  notifies :delete, 'file[delete tmp file]', :immediately
end
