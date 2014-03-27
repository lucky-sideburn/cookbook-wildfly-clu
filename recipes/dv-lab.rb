# Cookbook Name:: wildfly-clu
# Recipe:: dv-lab
#
# Copyright (C) 2014 Eugenio Marzo
# 
# All rights reserved - Do Not Redistribute
#

node.set['java']['jdk_version'] = "7"
node.set['java']['jdk']['7']['x86_64']['url'] = 'http://hqlprrepo01.hq.un.fao.org/jdk-7u40-linux-x64.tar.gz'
node.set['java']['jdk']['7']['x86_64']['checksum'] = '26a5511749793b66e8398f8e02b18e727163e3642205327c5f672e718438463b'


node.set['wildfly-clu']['cluster_schema']       = {
                                          "hqldvtcdrgf1.hq.un.fao.org"  => { :role => "domain-controller"   ,
                                                                             :ip => "168.202.5.230",  
									     :port_offset => "0" },

                                          "hqldvtcdrjob1.hq.un.fao.org"  => { :role => "slave"  , 
									      :ip => "168.202.5.253" , 
   									      :master => "hqldvtcdrgf1.hq.un.fao.org" , 
									      :port_offset => "0"},
 
                                          "hqldvtcdrjob2.hq.un.fao.org"  => { :role => "slave"  , 
									      :ip => "168.202.5.205" ,
								              :master => "hqldvtcdrgf1.hq.un.fao.org" ,
									      :port_offset => "0" }

                                                   }


node.set['wildfly-clu']['java_opts'] = {
                                                           "heap-size" => "1024m",
                                                           "max-heap-size" => "1024m",
                                                           "permgen-size" => "512m",
                                                           "max-permgen-size"  => "512m"  }

include_recipe "wildfly-clu"
include_recipe "wildfly-clu::domain"
include_recipe "wildfly-clu::logs"
