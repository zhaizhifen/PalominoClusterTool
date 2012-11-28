#
# Cookbook Name:: cloudera
# Recipe:: hadoop_datanode
#
# Author:: Cliff Erson (<cerson@me.com>)
# Author:: Istvan Szukacs (<istvan.szukacs@gmail.com>)
# Copyright 2012, Riot Games
#
# Significant modifications by Tim Ellis Oct 2012
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

include_recipe "cloudera"

if node[:hadoop][:release] == '4u2'
  package "hadoop-hdfs-datanode"
else
  package "hadoop-#{node[:hadoop][:version]}-datanode"
end

#Example hue-plugins-1.2.0.0+114.20-1.noarch 
package "hue-plugins" do
  # if you need a particular version of hue, uncomment this and define the vars
  #version "#{node[:hadoop][:hue_plugin_version]}-#{node[:hadoop][:hue_plugin_release]}"
  action :install
end

template "/etc/init.d/hadoop-0.20-datanode" do
  mode 0755
  owner "root"
  group "root"
  variables(
    :java_home => node[:java][:java_home]
  )
end

node[:hadoop][:hdfs_site]['dfs.data.dir'].split(',').each do |dir|
  directory dir do
    mode 0755
    owner "hdfs"
    group "hdfs"
    action :create
    recursive true
  end

  directory "#{dir}/lost+found" do
    owner "hdfs"
    group "hdfs"
  end
end

service "hadoop-#{node[:hadoop][:version]}-datanode" do
  action [ :start, :enable ]
end
