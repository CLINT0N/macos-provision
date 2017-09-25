#!/bin/sh
source environment.sh

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX
###############################################################################

echo ""
echo_ok "Setting computer name"
	sudo scutil --set ComputerName $COMPUTER_NAME
	sudo scutil --set HostName $COMPUTER_NAME
	sudo scutil --set LocalHostName $COMPUTER_NAME
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME

echo ""
echo_ok "Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before"
  echo_warn 'Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.'
	sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

echo ""
echo_ok "Change indexing order and disable some search results in Spotlight"
  # Yosemite-specific search results (remove them if your are using OS X 10.9 or older):
  #   MENU_DEFINITION
  #   MENU_CONVERSION
  #   MENU_EXPRESSION
  #   MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
  #   MENU_WEBSEARCH             (send search queries to Apple)
  #   MENU_OTHER
  defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 1;"name" = "PDF";}' \
    '{"enabled" = 1;"name" = "FONTS";}' \
    '{"enabled" = 1;"name" = "DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 1;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 0;"name" = "SOURCE";}' \
    '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0;"name" = "MENU_OTHER";}' \
    '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
    '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
  # Load new settings before rebuilding the index
  killall mds > /dev/null 2>&1
  # Make sure indexing is enabled for the main volume
  sudo mdutil -i on / > /dev/null
  # Rebuild the index from scratch
  sudo mdutil -E / > /dev/null

echo ""
echo_ok "Expanding the save panel by default"
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo ""
echo_ok "Automatically quit printer app once the print jobs complete"
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo ""
echo_ok "Save to disk, rather than iCloud, by default"
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo ""
echo_ok "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
	sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo ""
echo_ok "Check for software updates daily, not just once per week"
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

###############################################################################
# General Power and Performance modifications
###############################################################################

echo ""
echo_ok "Disable hibernation (speeds up entering sleep mode)"
	sudo pmset -a hibernatemode 0

echo ""
echo_ok "Disable the sudden motion sensor (it's not useful for SSDs/current MacBooks)"
	sudo pmset -a sms 0

echo ""
echo_ok "Disable system-wide resume"
	defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

echo ""
echo_ok "Speeding up wake from sleep to 24 hours from an hour"
	# http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
	sudo pmset -a standbydelay 86400

################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################

echo ""
echo_ok "Increasing sound quality for Bluetooth headphones/headsets"
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo ""
echo_ok "Enabling full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)"
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo ""
echo_ok "Setting a blazingly fast keyboard repeat rate"
	defaults write NSGlobalDomain KeyRepeat -int 0

echo ""
echo_ok "Disable auto-correct"
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo ""
echo_ok "Turn off keyboard illumination when computer is not used for 5 minutes"
	defaults write com.apple.BezelServices kDimTime -int 300

echo ""
echo_ok "Disable display from automatically adjusting brightness"
	sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false

echo ""
echo_ok "Disable keyboard from automatically adjusting backlight brightness in low light"
	sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool false

###############################################################################
# Screen
###############################################################################

echo ""
echo_ok "Screenshots to be stored in ~/Desktop"
	screenshot_location="${HOME}/Desktop"
	defaults write com.apple.screencapture location -string "${screenshot_location}"

echo ""
echo_ok "Setting screenshot format to PNG"
	defaults write com.apple.screencapture type -string "png"


###############################################################################
# Finder
###############################################################################

echo ""
echo_ok "Show icons for hard drives, servers, and removable media on the desktop"
	defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

echo ""
echo_ok "Show hidden files in Finder by default"
  defaults write com.apple.Finder AppleShowAllFiles -bool true

echo ""
echo_ok "Show dotfiles in Finder by default"
  defaults write com.apple.finder AppleShowAllFiles TRUE

echo ""
echo_ok "Show all filename extensions in Finder by default"
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo ""
echo_ok "Disable the warning when changing a file extension"
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo ""
echo_ok "Avoid creation of .DS_Store files on network volumes"
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo ""
echo_ok "Disable disk image verification"
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo ""
echo_ok "Allowing text selection in Quick Look/Preview in Finder by default"
	defaults write com.apple.finder QLEnableTextSelection -bool true

###############################################################################
# Dock & Mission Control
###############################################################################

echo ""
echo_ok "Wipe all (default) app icons from the Dock"
	defaults write com.apple.dock persistent-apps -array

echo ""
echo_ok "Speeding up Mission Control animations and grouping windows by application"
	defaults write com.apple.dock expose-animation-duration -float 0.1
	defaults write com.apple.dock "expose-group-by-app" -bool true

###############################################################################
# Chrome, Safari, & WebKit
###############################################################################

echo ""
echo_ok "Privacy: Don’t send search queries to Apple"
	defaults write com.apple.Safari UniversalSearchEnabled -bool false
	defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo ""
echo_ok "Hiding Safari's bookmarks bar by default"
	defaults write com.apple.Safari ShowFavoritesBar -bool false

echo ""
echo_ok "Hiding Safari's sidebar in Top Sites"
	defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo ""
echo_ok "Disabling Safari's thumbnail cache for History and Top Sites"
	defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

echo ""
echo_ok "Enabling Safari's debug menu"
	defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo ""
echo_ok "Making Safari's search banners default to Contains instead of Starts With"
	defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo ""
echo_ok "Removing useless icons from Safari's bookmarks bar"
	defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo ""
echo_ok "Enabling the Develop menu and the Web Inspector in Safari"
	defaults write com.apple.Safari IncludeDevelopMenu -bool true
	defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
	defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
echo_ok "Adding a context menu item for showing the Web Inspector in web views"
	defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo ""
echo_ok "Disabling the annoying backswipe in Chrome"
	defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
	defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

echo ""
echo_ok "Using the system-native print preview dialog in Chrome"
	defaults write com.google.Chrome DisablePrintPreview -bool true
	defaults write com.google.Chrome.canary DisablePrintPreview -bool true

###############################################################################
# Time Machine
###############################################################################

echo ""
echo_ok "Prevent Time Machine from prompting to use new hard drives as backup volume"
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Kill affected applications
###############################################################################
echo ""
echo_ok "Done!"
echo ""
echo ""
echo_warn "################################################################################"
echo ""
echo ""
echo_warn "Note that some of these changes require a logout/restart to take effect."
echo_warn "Killing some open applications in order to take effect."
echo ""
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
  "Terminal" "Transmission"; do
  killall "${app}" > /dev/null 2>&1
done