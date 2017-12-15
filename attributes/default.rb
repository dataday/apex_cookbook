#
# Cookbook:: apex_cookbook
# Attribute:: default
#
# Copyright:: 2017, dataday, All Rights Reserved.
#
# Description
# Default attributes used within the project

# kernel name
name = node['kernel']['name'].downcase
# kernel machine
machine = node['kernel']['machine'].downcase

# cookbook name
default[:apex_cookbook][:name]       = 'apex'
# cache path
default[:apex_cookbook][:tmp]        = Chef::Config[:file_cache_path]
# bin directory for executables
default[:apex_cookbook][:bin]        = '/opt/local/bin'
# etc directory for associated files
default[:apex_cookbook][:etc]        = '/etc/profile.d'
# owner used during installation
default[:apex_cookbook][:owner]      = 'root'
# group used during installation
default[:apex_cookbook][:group]      = 'root'
# mode applied during installation, u=rwx,g=rx,o=rx
default[:apex_cookbook][:mode]       = 0755
# remote Apex releases URL
default[:apex_cookbook][:releases]   = 'https://api.github.com/repos/apex/apex/tags'
# remote Apex download URL
default[:apex_cookbook][:download]   = 'https://github.com/apex/apex/releases/download/%s/apex_%s'
# local platform architecture
default[:apex_cookbook][:platform]   = %I[#{name} #{machine}]
# supported Apex platform architectures
default[:apex_cookbook][:platforms]  = {
                                          darwin:  %i[x86_64],
                                          linux:   %i[i686 x86_64],
                                          openbsd: %i[amd64],
                                          clones:  {
                                            x86_64: :amd64
                                          }
                                        }
