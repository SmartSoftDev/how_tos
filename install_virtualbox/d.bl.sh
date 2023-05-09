gblcmd_install_virtualbox_ub22(){
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
    sudo cp ./ub22.04_apt.source.d.list /etc/apt/source.d/virtualbox.list
    sudo apt update
    sudo apt-get install virtualbox
}