#!/bin/sh
source environment.sh

# install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/cask
brew tap homebrew/versions
brew tap homebrew/dupes
brew tap homebrew/php
brew tap homebrew/apache
brew tap caskroom/versions
brew tap caskroom/fonts

brew update

binaries=(
	brew-cask
	bash
	git
	python
	python3
	mariadb
	httpd24
	dnsmasq
	cmake
	yarn
	node
	composer
	thefuck
	curl
	wget
	zsh
	gettext
	openssl
	sqlite
	homebrew/dupes/grep
	phpunit
	mas
)

php55modules=(
	php55-apcu
	php55-intl
	php55-mcrypt
	php55-opcache
	php55-xdebug
	php55-yaml
)

php56modules=(
	php56-apcu
	php56-intl
	php56-mcrypt
	php56-opcache
	php56-xdebug
	php56-yaml
)

php70modules=(
	php70-apcu
	php70-intl
	php70-mcrypt
	php70-opcache
	php70-xdebug
	php70-yaml
)

php71modules=(
	php71-apcu
	php71-intl
	php71-mcrypt
	php71-opcache
	php71-xdebug
	php71-yaml
)

php72modules=(
	php72-apcu
	php72-intl
	php72-mcrypt
	php72-opcache
	php72-xdebug
	php72-yaml
)

apps=(
	firefox
	google-chrome
	opera
	filezilla
	sublime-text
	iterm2
	jetbrains-toolbox
	phpstorm
	intellij-idea-ce
	gitkraken
	sequel-pro
	keka
	battle-net
	twitch
	discord
	slack
	gifrocket
	spotify
	gyazo
	teamviewer
	real-vnc
	vlc
	java
	adobe-creative-cloud
	balsamiq-mockups
	flux
)

appstore=(
	447521961 # XChat Azure
	715768417 # Microsoft Remote Desktop
	408981434 # iMovie
	405772121 # LittleIpsum
)

# DISABLE BUILT-IN APACHE
apachectl stop
launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

# INSTALL BINARIES
echo "Installing Binaries"
brew install ${binaries[@]}

# CONFIGURE APACHE
echo "Configuring Apache"
apache_version=$(brew list --versions httpd24)
apache_version=$(echo $apache_version | cut -d' ' -f2-) #
cp -v /usr/local/Cellar/httpd24/$apache_version/homebrew.mxcl.httpd24.plist /Library/LaunchDaemons
chown -v root:wheel /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
chmod -v 644 /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
launchctl load /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist

# INSTALL PHP 55
echo "Installing PHP 5.5"
brew install php55 --with-httpd24
brew install ${php55modules[@]}
brew unlink php55

# INSTALL PHP 56
echo "Installing PHP 5.6"
brew install php56 --with-httpd24
brew install ${php56modules[@]}
brew unlink php56

# INSTALL PHP 70
echo "Installing PHP 7.0"
brew install php70 --with-httpd24
brew install ${php70modules[@]}
brew unlink php70

# INSTALL PHP 71
echo "Installing PHP 7.1"
brew install php71 --with-httpd24
brew install ${php71modules[@]}
brew unlink php71

# INSTALL PHP 72
echo "Installing PHP 7.2"
brew install php72 --with-httpd24
brew install ${php72modules[@]}

# INSTALL PHP SWITCHER SCRIPT
echo "Installing PHP Switcher Script"
curl -L https://gist.github.com/w00fz/142b6b19750ea6979137b963df959d11/raw > /usr/local/bin/sphp
chmod +x /usr/local/bin/sphp

# DOWNLOAD APACHE & PHP CONFIGS
if [ "$get_configs" = true]
then
	#wget -P $apache2_dir/ $apache2_config/httpd.conf
	#wget -P $apache2_dir/extra $apache2_config/extra/httpd-vhosts.conf
	echo "Fetching Apache Configuration from $sftp_host"
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$apache2_config/httpd.conf $apache2_dir
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$apache2_config/extra/httpd-vhosts.conf $apache2_dir/extra
	echo "Fetching PHP Configurations from $sftp_host"
	# PHP 55
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/55/php.ini $php55_dir
	mkdir $php55_dir/conf.d
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/55/conf.d/ext-xdebug.ini $php55_dir/conf.d
	# PHP 56
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/56/php.ini $php56_dir
	mkdir $php56_dir/conf.d
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/56/conf.d/ext-xdebug.ini $php56_dir/conf.d
	# PHP 70
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/70/php.ini $php70_dir
	mkdir $php70_dir/conf.d
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/70/conf.d/ext-xdebug.ini $php70_dir/conf.d
	# PHP 71
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/71/php.ini $php71_dir
	mkdir $php71_dir/conf.d
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/71/conf.d/ext-xdebug.ini $php71_dir/conf.d
	# PHP 72
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/72/php.ini $php72_dir
	mkdir $php72_dir/conf.d
	sftp -oPort=$sftp_port $sftp_user:$sftp_password@$sftp_host:$php_config/72/conf.d/ext-xdebug.ini $php72_dir/conf.d
	# RESTART APACHE
	apachectl -k restart
fi


# INSTALL APPS
echo "Installing Applications"
brew cask install --appdir=$app_dir ${apps[@]}

# INSTALL MAC APP STORE APPS
echo "Installing Applications from Mac App Store"
mas signin $apple_id_email "$apple_id_password"
mas install ${appstore[@]}

# CONFIGURE DNSMASQ