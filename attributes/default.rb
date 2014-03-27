default['wildfly-clu']['user']  = "wildfly"
default['wildfly-clu']['group'] = "wildfly"
default['wildfly-clu']['name']  = "wildfly"
default['wildfly-clu']['wildfly']['service'] = "wildfly"


default['wildfly-clu']['wildfly']['version'] = "8.0.0"
default['wildfly-clu']['wildfly']['url']="http://download.jboss.org/wildfly/8.0.0.Final/wildfly-8.0.0.Final.tar.gz"
default['wildfly-clu']['wildfly']['checksum']='7316100a8dae90a74fb96f9d70d758daee71ebd70d5ed680307082f010d6f3a9'
default['wildfly-clu']['wildfly']['targz'] = "wildfly-#{node['wildfly-clu']['wildfly']['version']}.Final.tar.gz"
default['wildfly-clu']['wildfly']['home']="/usr/local/#{node['wildfly-clu']['name']}"
default['wildfly-clu']['wildfly']['base'] = "/usr/local"
default['wildfly-clu']['wildfly']['logs'] = "/usr/local/#{node['wildfly-clu']['name']}/standalone/log"

#if you create this file the recipe  will not change domain.xml,host.xml and mgmt-******.properties  after the first installation
default['wildfly-clu']['wildfly']['lock'] = "/usr/local/#{node['wildfly-clu']['name']}/conf.lock"

#######################################################################
## Set the following variable to true if you want use the domain mode.
default['wildfly-clu']['mode']['domain'] = true
##
####################################################################### 


if  node['wildfly-clu']['mode']['domain']

 default['wildfly-clu']['wildfly']['logs']      = "/usr/local/#{node['wildfly-clu']['name']}/domain/log"
 default['wildfly-clu']['wildfly']['conf_path'] = "/usr/local/#{node['wildfly-clu']['name']}/domain/configuration"

 #set this to true in order to deploy an helloworld application
 default['wildfly-clu']['wildfly']['deploy_hello_world'] = true

 #set this to true in order to configure an haproxy with the slaves declared in the cluster_schema
 default['wildfly-clu']['wildfly']['haproxy'] = true

 #password for the slave realm.. use encrypted databag for increase security
 default['wildfly-clu']['wildfly']['ManagementRealm'] = "a2VybmVscGFuaWMhMTIz"

 #username:  slave
 #password:  kernelpanic!123
 #In order to configure different user with a different password:
 #1. launch on the domain controller server add-user.sh
 #2. create and user 
 #3. Is this new user going to be used for one AS process to connect to another AS process? 
 #e.g. for a slave host controller connecting to the master or for a Remoting connection for server to server EJB calls.
 #yes/no? yes
 #4. Replace mgmt-users.properties mgmt-groups.properties with new new ones in the template dir of this cookbook. 


 default['wildfly-clu']['cluster_schema']       = { 
					  "myserver1"  => { :role => "domain-controller" , :ip => "33.33.33.11",  :port_offset => "0" },
					  "myserver2"  => { :role => "slave"  , :ip => "33.33.33.12" , :master => "myserver1" , :port_offset => "0"},
					  "myserver3"  => { :role => "slave"  , :ip => "33.33.33.13" , :master => "myserver1" , :port_offset => "0" }

					           }


 #DEFAULT java options to use in all slaves and the master for run the application. 
 default['wildfly-clu']['java_opts'] = { 	
						           "heap-size" => "64m",
							   "max-heap-size" => "64m",
							   "permgen-size" => "64m",
							   "max-permgen-size"  => "64m"  }




end 					      
