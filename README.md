# wildfly-clu cookbook

# Requirements

Centos 6.x



# Usage
  With Vagrant:

  cd wildfly-clu &&  vagrant up

  With Chef: 
 
  add [ wildfly-clu:default ,wildfly-clu:logs, wildfly:domain ] in your run list:

        "recipe[java]",
        "recipe[wildfly-clu::default]",
        "recipe[wildfly-clu::logs]",
        "recipe[wildfly-clu::domain]"

  
      #DEFINE EASLY YOUR CLUSTER
        default['wildfly-clu']['cluster_schema']       = {
                                          "myserver1"  => { :role => "domain-controller" , :ip => "33.33.33.13",  :port_offset => "0" },
                                          "myserver2"  => { :role => "slave"  , :ip => "33.33.33.11" , :master => "myserver1" , :port_offset => "0"},
                                          "myserver3"  => { :role => "slave"  , :ip => "33.33.33.12" , :master => "myserver1" , :port_offset => "0" }

                                                   }
 
# Attributes

 #user, group and application name ( app name will be /usr/local/myapplication and /etc/init.d/myapplication)

	default['wildfly-clu']['user']  = "wildfly"		   (user name)
	default['wildfly-clu']['group'] = "wildfly"                (group name)
	default['wildfly-clu']['name']  = "wildfly"                (/usr/local/SYMBOLIC_LINK  => /usr/local/wildfly-8.8.8-Final)
        default['wildfly-clu']['wildfly']['service'] = "wildfly"   (/etc/init.d/SERVICE_NAME)


	default['wildfly-clu']['wildfly']['version'] 
	default['wildfly-clu']['wildfly']['url']
	default['wildfly-clu']['wildfly']['checksum'] 
	default['wildfly-clu']['wildfly']['targz']   (the downloaded tar.gz file)
	default['wildfly-clu']['wildfly']['home']  
	default['wildfly-clu']['wildfly']['base']    (usually is /usr/local)
	default['wildfly-clu']['wildfly']['logs']  

        default['wildfly-clu']['wildfly']['deploy_hello_world'] = true

 	set this to true in order to configure an haproxy with the slaves declared in the cluster schema
 	default['wildfly-clu']['wildfly']['haproxy'] = true

	 #password for the slave realm.. use encrypted databag for increase security
 	 default['wildfly-clu']['wildfly']['ManagementRealm'] = "a2VybmVscGFuaWMhMTIz"

         Default credential for Wildfly console:
                 username:  admin
		 password:  admin	
         Default username for slave-master communication:
   	         username:  slave
  		 password:  kernelpanic!123
	 #In order to configure different user with a different password:
	 #1. launch on the domain controller server add-user.sh
	 #2. create and user 
 	 #3. Is this new user going to be used for one AS process to connect to another AS process? 
 	 #e.g. for a slave host controller connecting to the master or for a Remoting connection for server to server EJB calls.
 	 #yes/no? yes
	 #4. Replace mgmt-users.properties mgmt-groups.properties with new new ones in the template dir of this cookbook. 


         # THE CLUSTER DEFINITION
         default['wildfly-clu']['cluster_schema']       = {
                                          "myserver1"  => { :role => "domain-controller" , :ip => "33.33.33.13",  :port_offset => "0" },
                                          "myserver2"  => { :role => "slave"  , :ip => "33.33.33.11" , :master => "myserver1" , :port_offset => "0"},
                                          "myserver3"  => { :role => "slave"  , :ip => "33.33.33.12" , :master => "myserver1" , :port_offset => "0" }

                                                   }


          # DEFAULT java options to use in all slaves and the master for run your deployed the applications. 
           default['wildfly-clu']['java_opts'] = { "heap-size" => "128m",
                                                           "max-heap-size" => "128m",
                                                           "permgen-size" => "128m",
                                                           "max-permgen-size"  => "128m"  }




# Recipes
	default => install Wildfly
	domain  => configure your cluster
	haproxy => install haproxy to see quickly the cluster works
        logs    => configure log rotation
# Author

Author:: Eugenio Marzo  (eugenio.marzo@yahoo.it)
