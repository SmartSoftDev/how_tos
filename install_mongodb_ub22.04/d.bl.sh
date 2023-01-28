gblcmd_install_mongodb_ub22.04(){
    # see https://www.mongodb.com/docs/v6.0/tutorial/install-mongodb-on-ubuntu/ (but it is sometimes OBSOLETE)
    # see https://wiki.crowncloud.net/How_To_Install_Duf_On_Ubuntu_22_04?How_to_Install_Latest_MongoDB_on_Ubuntu_22_04
    set -e
    apt install -y dirmngr gnupg apt-transport-https ca-certificates software-properties-common

    echo "Add mongo 6.0 into apt source list"
    sudo cp mongodb-org-6.0.list /etc/apt/sources.list.d/
    echo "Add/trust mongo DB pgp public key to the system"
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
    sudo apt update
    echo "Install mongo DB"
    sudo apt install mongodb-org
    echo "Install at startup ..."
    sudo systemctl start mongod
    sudo systemctl enable mongod
    echo "Done"
    set +e
}