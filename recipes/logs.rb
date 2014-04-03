# Cookbook Name::   wildfly-clu
# Recipe::          logs
# Maintainer_email 'eugenio.marzo@yahoo.it'
# License          'GPL'

package "crontabs" 

wildfly_name  =   node['wildfly-clu']['name']
wildfly_user  =   node['wildfly-clu']['user']
wildfly_group =   node['wildfly-clu']['group']
wildfly_home  =   node['wildfly-clu']['wildfly']['home']
wildfly_targz =   node['wildfly-clu']['wildfly']['targz']
wildfly_url   =   node['wildfly-clu']['wildfly']['url']
wildfly_base  =   node['wildfly-clu']['wildfly']['base']
wildfly_service = node['wildfly-clu']['wildfly']['service']
wildfly_logs  =   node['wildfly-clu']['wildfly']['logs']

logrotate_app "wildfly_console"  do
  cookbook "logrotate"
  path     "#{wildfly_logs}/console.log"
  frequency "daily"
  rotate     30
  create    "664 #{wildfly_user} #{wildfly_group}"
end


cron_commands =  [
 
"find #{wildfly_logs}  -name '*' -a ! -name '*.gz' -mtime +1  -a ! -name 'console.log'  -a ! -name 'boot.log'   -exec gzip '{}' \;",

"find #{wildfly_logs}  -name '*.txt' -a ! -name '*.gz' -mtime +1  -a ! -name 'console.log'  -a ! -name 'boot.log'   -exec gzip '{}' \;",

"find #{wildfly_logs}  -name '*.gz'  -mtime +30  -exec rm -f '{}' \;",

"find #{wildfly_logs}  -name '*.txt.gz'  -mtime +30  -exec rm -f '{}' \;"

                  ]
cnt=0
cron_commands.each do |c|
 cron "Wildfly log rotation #{cnt.to_s}" do
   minute "0"
   hour   "0"
   command c
 end
cnt =+ 1 
end
