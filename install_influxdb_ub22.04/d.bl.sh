gblcmd_install_influxdb_ub22(){
    echo "Install influxdata GPG key and APT repository"
    # influxdata-archive_compat.key GPG Fingerprint: 9D539D90D3328DC7D6C8D3B9D8FF8E1F7DF8B07E
    wget -q https://repos.influxdata.com/influxdata-archive_compat.key
    echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
    sudo cp ./influxdata.list /etc/apt/sources.list.d/
    echo "Install influx"
    sudo apt update
    sudo apt install -y influxdb
    sudo systemctl start influxdb
    sudo systemctl enable influxdb
    echo "Done"
}