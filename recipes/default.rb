# Cookbook Name::   wildfly-clu
# Recipe:: 	    default
# Maintainer_email 'eugenio.marzo@yahoo.it'
# License          'GPL'


wildfly_user  =   node['wildfly-clu']['user']
wildfly_group =   node['wildfly-clu']['group']
wildfly_home  =   node['wildfly-clu']['wildfly']['home']
wildfly_targz =   node['wildfly-clu']['wildfly']['targz']
wildfly_url   =   node['wildfly-clu']['wildfly']['url']
wildfly_base  =   node['wildfly-clu']['wildfly']['base']
wildfly_service = node['wildfly-clu']['wildfly']['service']
wildfly_log    =  node['wildfly-clu']['wildfly']['logs']

user wildfly_user
group wildfly_group

remote_file "wildfly"  do
 owner  wildfly_user
 group  wildfly_group
 mode   0775
 source wildfly_url
 path   "#{wildfly_base}/#{wildfly_targz}"
 not_if { ::File.exists? wildfly_home }
 notifies :run,"bash[wildfly_extract]" , :immediately
end


bash "wildfly_extract" do
 code <<-EOH
  cd #{wildfly_base}
  [ -e #{ wildfly_targz } ] && tar -xvf #{ wildfly_targz }  
  rm -f #{wildfly_targz}
  cp  #{wildfly_base}/#{ wildfly_targz.gsub('.tar.gz','') }/bin/init.d/wildfly-init-redhat.sh  /etc/init.d/#{wildfly_service}
  chmod 744 /etc/init.d/#{wildfly_service}
  chown  -R #{wildfly_user}:#{wildfly_group} #{ wildfly_targz.gsub('.tar.gz','') }  
  EOH
  notifies :create,"link[#{wildfly_home}]" , :immediately
  action :nothing
end


link wildfly_home do
 to "#{wildfly_base}/#{wildfly_targz.gsub('.tar.gz','')}"
 notifies :create,"template[/etc/default/wildfly.conf]", :immediately
end


template "/etc/default/wildfly.conf" do
  source "wildfly.conf.erb"
  owner wildfly_user
  mode "0775"
  notifies :create, "directory[#{wildfly_log}]",:immediately
end


#Wildfly write console.log as root. For this reason I will create the log directory with an SGID Bit. In this way the group owner of the fil
#will be wildfly
#su - $JBOSS_USER -c "LAUNCH_JBOSS_IN_BACKGROUND=1 JBOSS_PIDFILE=$JBOSS_PIDFILE $JBOSS_SCRIPT --domain-config=$JBOSS_DOMAIN_CONFIG --host-config=$JBOSS_HOST_CONFIG" >> $JBOSS_CONSOLE_LOG 2>&1 &


directory node['wildfly-clu']['wildfly']['logs'] do
 owner wildfly_user
 group wildfly_group
 mode "2775"
 notifies :enable, "service[#{wildfly_service}]",:delayed
 notifies :restart, "service[#{wildfly_service}]",:delayed
 action :nothing
end



service wildfly_service do
 supports :status => true,:restart => true, :stop => true, :start => true
 action [:nothing]
end
