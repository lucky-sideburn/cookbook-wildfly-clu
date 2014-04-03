# Cookbook Name::   wildfly-clu
# Recipe::          domain
# Maintainer_email 'eugenio.marzo@yahoo.it'
# License          'GPL'


wildfly_user  =   node['wildfly-clu']['user']
wildfly_group =   node['wildfly-clu']['group']
wildfly_name  =   node['wildfly-clu']['name']
wildfly_home  =   node['wildfly-clu']['wildfly']['home']
wildfly_targz =   node['wildfly-clu']['wildfly']['targz']
wildfly_url   =   node['wildfly-clu']['wildfly']['url']
wildfly_base  =   node['wildfly-clu']['wildfly']['base']
wildfly_service = node['wildfly-clu']['wildfly']['service']
wildfly_conf_path = node['wildfly-clu']['wildfly']['conf_path']

#you can use alse the hostsfile cookbook..
node['wildfly-clu']['cluster_schema'].keys.each do |k|
 ruby_block "add record for #{k}" do
  block do
    if not File.open("/etc/hosts").to_a.to_s.include? "#{k}"
       File.open("/etc/hosts","a") {|f| f.write("#{node['wildfly-clu']['cluster_schema'][k][:ip]} #{k} \n")}
    end
   end
  end
 end


if node['wildfly-clu']['cluster_schema'][node.name][:role] == "domain-controller"

   conf_source = "host_domain_controller.xml.erb"
   domain_source = "domain.xml.erb"
 
   template "#{wildfly_conf_path}/domain.xml"do
     source domain_source
     owner  wildfly_user
     group  wildfly_group
     mode  "0775"
     notifies :restart, "service[#{wildfly_service}]",:delayed
     not_if { ::File.exists? node['wildfly-clu']['wildfly']['lock'] }
   end
  
   if node['wildfly-clu']['wildfly']['haproxy']

          package "haproxy" do
           action :install
           notifies :create, "template[/etc/haproxy/haproxy.cfg]"
          end

   	  template "/etc/haproxy/haproxy.cfg"do
      	   source   "haproxy.cfg.erb"
    	   owner    "root"
       	   group    "root"
           mode     "0775"
           notifies :restart, "service[haproxy]",:delayed
           not_if { ::File.exists? node['wildfly-clu']['wildfly']['lock'] }
         end  

         service "haproxy" do
	    supports :status => true,:restart => true, :stop => true, :start => true
	    action [:enable,:start]
	 end
 
   end


elsif node['wildfly-clu']['cluster_schema'][node.name][:role] == "slave"
   conf_source = "host_slave.xml.erb"
end


template "#{wildfly_conf_path}/host.xml"do
  source conf_source
  owner  wildfly_user
  group  wildfly_group
  mode  "0775"
  notifies :restart, "service[#{wildfly_service}]",:delayed
  not_if { ::File.exists? node['wildfly-clu']['wildfly']['lock'] }
end


template "#{wildfly_conf_path}/mgmt-groups.properties"do
  source "mgmt-groups.properties.erb"
  owner  wildfly_user
  group  wildfly_group
  mode  "0775"
  notifies :restart, "service[#{wildfly_service}]",:delayed
  not_if { ::File.exists? node['wildfly-clu']['wildfly']['lock'] }
end

template "#{wildfly_conf_path}/mgmt-users.properties"do
  source "mgmt-users.properties.erb"
  owner  wildfly_user
  group  wildfly_group
  mode  "0775"
  notifies :restart, "service[#{wildfly_service}]",:delayed
  not_if { ::File.exists? node['wildfly-clu']['wildfly']['lock'] }
end


if  node['wildfly-clu']['cluster_schema'][node.name][:role] == "domain-controller" and  node['wildfly-clu']['wildfly']['deploy_hello_world']

  cookbook_file "helloworld.war" do
   path "/tmp/helloworld.war"
   owner  wildfly_user
   group  wildfly_group
   mode  "0775"
   notifies :run, "bash[deploy_helloworld]",:delayed
  end
 

  bash "deploy_helloworld" do
   user wildfly_user
   code <<-EOH
   cd #{wildfly_base}/#{wildfly_name}/bin
   /bin/sh jboss-cli.sh --connect --command="deploy /tmp/helloworld.war --all-server-groups"
   EOH
  action :nothing
 end
  
end

