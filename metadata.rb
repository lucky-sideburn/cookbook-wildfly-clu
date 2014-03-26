name             'wildfly-clu'
maintainer       'Eugenio Marzo'
maintainer_email 'eugenio.marzo@yahoo.it'
license          'GPL'
description      'Installs/Configures wildfly-clu in domain mode'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ java cron logrotate hostsfile }.each do |p|
  depends p
end
