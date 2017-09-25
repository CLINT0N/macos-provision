#!/bin/sh

# USER DETAILS
USERNAME="example"
COMPUTER_NAME="EXAMPLE"

APPLE_ID_EMAIL="example@example.com"

# RESOURCE DETAILS
GET_CONFIGS=true
SFTP_HOST="host.example.com"
SFTP_USER="example"
SFTP_PASSWORD="example"
SFTP_PORT=22

RESOURCE_ADDRESS="/home/example/provision/$COMPUTER_NAME"
APACHE2_CONFIG="$RESOURCE_ADDRESS/config/apache2"
PHP_CONFIG="$RESOURCE_ADDRESS/config/php"

# PROJECT DIRECTORY
PROJECT_DIRECTORY="/Users/$USERNAME/Projects"
PROJECT_SYMLINK=false
PROJECT_SYMLINK_DIR="/Volumes/Projects"

# DIRECTORIES
APP_DIR="~/Applications"
APACHE2_DIR="/usr/local/etc/apache2/2.4"
PHP55_DIR="/usr/local/etc/php/5.5"
PHP56_DIR="/usr/local/etc/php/5.6"
PHP70_DIR="/usr/local/etc/php/7.0"
PHP71_DIR="/usr/local/etc/php/7.1"
PHP72_DIR="/usr/local/etc/php/7.2"


# HELPERS
function echo_ok { echo '\033[1;32m'"$1"'\033[0m'; }
function echo_warn { echo '\033[1;33m'"$1"'\033[0m'; }
function echo_error { echo '\033[1;31mERROR: '"$1"'\033[0m'; }
