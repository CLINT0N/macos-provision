# osx-provision (Work in Progress)
MacOS Provisioning Script


Installs various binaries and applications defined in arrays at the top of ```applications.sh```

Disables native apache, installs homebrew apache, installs PHP 5.5, 5.6, 7.0, 7.1 and 7.2 + PHP Switcher Script (sphp)

Retrieves existing configuration files stored on a web server from a directory structure like below:

- provision
-- MACHINENAME
--- config
---- apache2
----- httpd.conf
----- httpd-vhosts.conf
---- php
----- 55
------ php.ini
------ conf.d
------- ext-xdebug.ini
----- 56
------ php.ini
------ conf.d
------- ext-xdebug.ini
----- 70
------ php.ini
------ conf.d
------- ext-xdebug.ini
----- 71
------ php.ini
------ conf.d
------- ext-xdebug.ini
----- 72
------ php.ini
------ conf.d
------- ext-xdebug.ini

Installs Applications from Mac App Store using mas-cli, these apps are defined in ```appstore``` within ```applications.sh```

Configures dnsmasq for local .dev domains.

To be continued..