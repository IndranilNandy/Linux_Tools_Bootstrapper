#!/usr/bin/env bash

bootstrap() {
    sudo apt --fix-broken install -y
    yes | sudo apt update
    yes | sudo apt upgrade
    yes | sudo apt install git

    echo -e "Downloading the bootstrapper script..."
    git clone -b master https://github.com/IndranilNandy/Linux_Tools_Bootstrapper.git ~/MyTools/Linux_Tools_Bootstrapper

    cd ~/MyTools/Linux_Tools_Bootstrapper
    git checkout master

    # Enable execution permission on all shell scripts
    find . -name "*.sh" -exec chmod +x {} \;
    # Enable execution permission on all .setup
    find . -name ".setup" -exec chmod +x {} \;

    (
        cd remotemachinesetup
        ./fetch_setup_script.sh
    )
}

export GPG_TTY=$(tty)
bootstrap
