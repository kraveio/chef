name             'consul-kio'
maintainer       'Franklin Wise'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures consul-kio'
long_description 'Installs/Configures consul-kio'
version          '0.1.1'

depends 'consul'

suggests 'aws-util', '~> 0.1.0' # for server ip discovery
