#!/bin/sh

# USER DETAILS
username="user"
machine_name="EXAMPLE"

apple_id_email="user@example.com"
apple_id_password=""

# RESOURCE DETAILS
get_configs=true
sftp_host="host.example.com"
sftp_user="username"
sftp_password="password"
sftp_port=22

resource_address="/home/macos/provision/$machine_name"
apache2_config="$resource_address/config/apache2"
php_config="$resource_address/config/php"

# PROJECT DIRECTORY
project_directory="~/Projects"
project_symlink=false
project_symlink_dir="/Volumes/Projects/Development"

# DIRECTORIES
app_dir="~/Applications"
apache2_dir="/usr/local/etc/apache2/2.4"
php55_dir="/usr/local/etc/php/5.5"
php56_dir="/usr/local/etc/php/5.6"
php70_dir="/usr/local/etc/php/7.0"
php71_dir="/usr/local/etc/php/7.1"
php72_dir="/usr/local/etc/php/7.2"