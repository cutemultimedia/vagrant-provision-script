#!/bin/bash

echo "==================== Provisioning script starting ==================== "

PROVISION_SOURCE_REPO_INSTALLERS="https://github.com/ersongit/vagrant-provision-script.git"

TIME_STAMP=$(date +%s)
VAGRANT_TITLE="provision-$TIME_STAMP"

PROJECT_FOLDER="/var/www/html/$VAGRANT_TITLE"

VAGRANT_URL="https://dl.dropboxusercontent.com/u/100138133/vagrant/fresh-ubuntu-14-04.box"
VAGRANT_SYNCED_FOLDER_FROM="$PROJECT_FOLDER/vagrant-provision-script"
VAGRANT_SYNCED_FOLDER_TO="/home/vagrant"

while [ "$1" != "" ]; do
	case $1 in
		--title ) VAGRANT_TITLE=$2
							;;
		--url ) VAGRANT_URL=$2
							;;
		--project ) PROJECT_FOLDER=$2
							;;
		--sfrom ) VAGRANT_SYNCED_FOLDER_FROM=$2
							;;
		--sto ) VAGRANT_SYNCED_FOLDER_TO=$2
							;;
		esac
	shift
done

echo "Vagrant Box Name : $VAGRANT_TITLE"
echo "Vagrant Base Box File : $VAGRANT_URL"
echo "Vagrant Project Folder : $PROJECT_FOLDER"
echo "Synced Folder From : $VAGRANT_SYNCED_FOLDER_FROM"
echo "Synced Folder To : $VAGRANT_SYNCED_FOLDER_TO"

echo "Will provision in 3 seconds"; sleep 1; sleep 1; sleep 1;

[ -d PROJECT_FOLDER ] && echo "Project directory exists" || mkdir "$PROJECT_FOLDER"

cd "$PROJECT_FOLDER"

git clone "$PROVISION_SOURCE_REPO_INSTALLERS"

VAGRANT_CONFIG="VAGRANTFILE_API_VERSION = \"2\"\n\n\n"
VAGRANT_CONFIG="$VAGRANT_CONFIG Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|\n"
VAGRANT_CONFIG="$VAGRANT_CONFIG\tconfig.vm.box = \"$VAGRANT_TITLE\"\n"
VAGRANT_CONFIG="$VAGRANT_CONFIG\tconfig.vm.network :public_network\n"
VAGRANT_CONFIG="$VAGRANT_CONFIG\tconfig.vm.synced_folder \"$VAGRANT_SYNCED_FOLDER_FROM\", \"$VAGRANT_SYNCED_FOLDER_TO\", create:true\n"

VAGRANT_CONFIG="$VAGRANT_CONFIG\tconfig.vm.provision \"shell\", path: \"$PROJECT_FOLDER/vagrant-provision-script/provision/update.sh\"\n"
VAGRANT_CONFIG="$VAGRANT_CONFIG\tconfig.vm.provision \"shell\", path: \"$PROJECT_FOLDER/vagrant-provision-script/provision/apache2.sh\"\n"
VAGRANT_CONFIG="$VAGRANT_CONFIG\tconfig.vm.provision \"shell\", path: \"$PROJECT_FOLDER/vagrant-provision-script/provision/php5.sh\"\n"
VAGRANT_CONFIG="$VAGRANT_CONFIG\tconfig.vm.provision \"shell\", path: \"$PROJECT_FOLDER/vagrant-provision-script/provision/etc.sh\"\n"

VAGRANT_CONFIG="$VAGRANT_CONFIG end\n"

echo "$VAGRANT_CONFIG" > "$PROJECT_FOLDER/Vagrantfile"

vagrant box add "$VAGRANT_TITLE" "$VAGRANT_URL"
vagrant up

echo "==================== Provisioning script end      ==================== "
