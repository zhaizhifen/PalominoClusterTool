#
# Cookbook Name:: cloudera
# Recipe:: hbase_thrift
#
# Author:: Istvan Szukacs (<istvan.szukacs@gmail.com>)
# Copyright 2012, Riot Games
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

if node[:hadoop][:release] == '4u2'
  package "hbase-thrift"
else
  package "hadoop-hbase-thrift"
end

template "/etc/init.d/hadoop-hbase-thrift" do
  source "hadoop_hbase_thrift.erb"
  mode 0755
  owner "root"
  group "root"
  variables(
    :java_home => node[:java][:java_home]
  )
end

service "hadoop-hbase-thrift" do
  action [ :start, :enable ]
end
