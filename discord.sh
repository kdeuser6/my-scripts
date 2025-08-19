#!/bin/bash

# Environment variables
app_name=discord
literal_name_of_installation_directory="$HOME/.tarball-installations"
app_installation_directory="$literal_name_of_installation_directory/Discord"
tar_location="/tmp/discord.tar.gz"
local_bin_path="$HOME/.local/bin"
local_application_path="$HOME/.local/share/applications"
app_bin_in_local_bin="$local_bin_path/Discord"
desktop_in_local_applications="$local_application_path/discord.desktop"
icon_path="$app_installation_directory/discord.png"
executable_path=$app_installation_directory/Discord

# Function for installation
function installFunction() {
	# Let's start
	echo "Welcome to Discord installer!"
	sleep 1

	# Download the tarball
	echo "Downloading the tarball..."
	sleep 1
	echo ""
	wget "https://discord.com/api/download?platform=linux&format=tar.gz" -O $tar_location
	if [ $? -eq 0 ]; then
		echo "Done!"
	else
		echo "Failed. Wget not found or there is an error."
		sleep 1
		exit 1
	fi

	# Create an installation directory and extract the tarball
	if [ ! -d $literal_name_of_installation_directory ]; then
		mkdir $literal_name_of_installation_directory
	fi
	echo "Extracting the tarball..."
	tar -xvf $tar_location -C $literal_name_of_installation_directory
	echo "Extracted successfully!"
	sleep 1

	# Create a local PATH and link the executable to PATH
	if [ ! -d $local_bin_path ]; then
		mkdir $local_bin_path
	fi
	ln -s $app_installation_directory/Discord $local_bin_path/Discord
	echo "Executable linked to PATH if you ever need."

	# Fix .desktop file and move it to applications path
	sed -i "s+Icon=discord+Icon=${app_installation_directory}/discord.png+g" "${app_installation_directory}/discord.desktop"
	sed -i "s+Exec=/usr/share/discord/Discord+Exec=${executable_path}+g" "${app_installation_directory}/discord.desktop"
	mv $app_installation_directory/discord.desktop $local_application_path
	echo "Desktop file moved to local applications path successfully!"
}

# Function for uninstallation
function removeFunction() {
	# Let's start
	echo "Starting to uninstallation..."
	sleep 1

	# Remove the .desktop file
	rm $desktop_in_local_applications

	# Remove the executable
	rm $app_bin_in_local_bin

	# Finally remove the app files
	rm -rf $app_installation_directory

	# Final message
	echo "All files removed successfully!"
}

function menuFunction() {
	echo "It looks Discord is already installed."
	sleep 1
	echo ""
	echo "What do you want?"
	echo "   1) Exit"
	echo "   2) Remove Discord"
	echo "   3) Update (reinstall) Discord"
	until [[ $menu =~ ^[1-3]$ ]]; do
		read -rp "Select an option [1-3]: " menu
	done

	case $menu in
	1)
		exit
		;;
	2)
		removeFunction
		echo ""
		echo "Discord removed successfully!"
		exit
		;;
	3)
		echo "Warning! When Discord updated (reinstalled), you will need to relogin."
		sleep 1
		echo ""
		removeFunction
		echo ""
		installFunction
		echo ""
		echo "Discord updated (reinstalled) successfully!"
		exit
		;;
	esac
}

# Check the files and run the functions
if [ ! -d $app_installation_directory ]; then
	echo "Welcome to Discord installer!"
	sleep 1
	echo ""
	installFunction
	echo ""
	echo "Discord installation completed successfully!"
	exit
else
	echo "Welcome to Discord installer!"
	sleep 1
	echo ""
	menuFunction
fi
