#!/bin/sh
source environment.sh

echo_warn "You may be prompted for sudo password multiple times throughout installation"
# install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/cask
brew tap homebrew/php
brew tap homebrew/apache
brew tap caskroom/versions
brew tap caskroom/fonts
brew tap hudochenkov/sshpass

binaries=(
	zsh
	zsh-completions
	sshpass
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
	grep
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
	1278508951 # Trello
)

# DISABLE BUILT-IN APACHE
apachectl stop
launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

# INSTALL BINARIES
echo ""
echo_ok "Installing Binaries"
brew install ${binaries[@]}

# CONFIGURE APACHE
echo ""
echo_ok "Configuring Apache"
apache_version=$(brew list --versions httpd24 | cut -d' ' -f2-)
sudo cp -v /usr/local/Cellar/httpd24/$apache_version/homebrew.mxcl.httpd24.plist /Library/LaunchDaemons
sudo chown -v root:wheel /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
sudo chmod -v 644 /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
launchctl load /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist

# MAKE SURE ALL PHP UNLINKED
brew unlink php55
brew unlink php56
brew unlink php70
brew unlink php71
brew unlink php72

# INSTALL PHP 55
echo ""
echo_ok "Installing PHP 5.5"
brew install php55 --with-httpd24
brew install ${php55modules[@]}
brew unlink php55

# INSTALL PHP 56
echo ""
echo_ok "Installing PHP 5.6"
brew install php56 --with-httpd24
brew install ${php56modules[@]}
brew unlink php56

# INSTALL PHP 70
echo ""
echo_ok "Installing PHP 7.0"
brew install php70 --with-httpd24
brew install ${php70modules[@]}
brew unlink php70

# INSTALL PHP 71
echo ""
echo_ok "Installing PHP 7.1"
brew install php71 --with-httpd24
brew install ${php71modules[@]}
brew unlink php71

# INSTALL PHP 72
echo ""
echo_ok "Installing PHP 7.2"
brew install php72 --with-httpd24
brew install ${php72modules[@]}

# INSTALL PHP SWITCHER SCRIPT
echo ""
echo_ok "Installing PHP Switcher Script"
curl -L https://gist.github.com/w00fz/142b6b19750ea6979137b963df959d11/raw > /usr/local/bin/sphp
sudo chmod +x /usr/local/bin/sphp

# DOWNLOAD APACHE & PHP CONFIGS
if [ "$GET_CONFIGS" = true ] ;
then
echo ""
	echo_ok "Downloading Apache Configuration from $SFTP_HOST"
	ssh-keygen -R $SFTP_HOST
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$APACHE2_CONFIG/httpd.conf $APACHE2_DIR
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$APACHE2_CONFIG/extra/httpd-vhosts.conf $APACHE2_DIR/extra
	echo ""
	echo_ok "Downloading PHP Configurations from $SFTP_HOST"
	# PHP 55
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/55/php.ini $PHP55_DIR
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/55/conf.d/ext-xdebug.ini $PHP55_DIR/conf.d
	# PHP 56
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/56/php.ini $PHP56_DIR
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/56/conf.d/ext-xdebug.ini $PHP56_DIR/conf.d
	# PHP 70
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/70/php.ini $PHP70_DIR
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/70/conf.d/ext-xdebug.ini $PHP70_DIR/conf.d
	# PHP 71
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/71/php.ini $PHP71_DIR
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/71/conf.d/ext-xdebug.ini $PHP71_DIR/conf.d
	# PHP 72
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/72/php.ini $PHP72_DIR
	sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$PHP_CONFIG/72/conf.d/ext-xdebug.ini $PHP72_DIR/conf.d
	# RESTART APACHE
	sudo apachectl -k restart
fi 


# INSTALL APPS
echo ""
echo_ok "Installing Applications"
brew cask install --appdir=$app_dir ${apps[@]}

# INSTALL MAC APP STORE APPS
echo ""
echo_ok "Installing Applications from Mac App Store"
mas signin --dialog $apple_id_email
mas install ${appstore[@]}

# CONFIGURE DNSMASQ
echo ""
echo_ok "Configuring dnsmasq"
echo 'address=/.dev/127.0.0.1' > /usr/local/etc/dnsmasq.conf
sudo brew services start dnsmasq
sudo mkdir -v /etc/resolver
sudo touch /etc/resolver/dev
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'

# CREATE PROJECT DIRECTORIES
echo ""
echo_ok "Creating Project Directory"
sudo mkdir $PROJECT_DIRECTORY
if [ "$PROJECT_SYMLINK" = true ] ;
then
	echo ""
	echo_ok "Linking Project Directory"
	ln -s $PROJECT_SYMLINK_DIR $PROJECT_DIRECTORY
fi

# INSTALL OH MY ZSH
echo ""
echo_ok "Installing Oh My Zsh"
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
echo ""
echo_ok "Downloading .zshrc from $SFTP_HOST"
sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$RESOURCE_ADDRESS/zsh/.zshrc /Users/$USERNAME
echo ""
echo_ok "Downloading env.sh from $SFTP_HOST"
mkdir /Users/$USERNAME/zsh
sshpass -p $SFTP_PASSWORD sftp -o StrictHostKeyChecking=no -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST:$RESOURCE_ADDRESS/zsh/zsh/env.sh /Users/$USERNAME/zsh/env.sh
echo ""
echo_ok "Changing default shell to zsh"
sudo chsh -s /usr/local/bin/zsh
echo ""
echo_ok "Done!"
echo ""
echo ""
echo_warn "################################################################################"
echo ""
echo_warn "Note that some of these changes may require a logout/restart to take effect."
echo ""
