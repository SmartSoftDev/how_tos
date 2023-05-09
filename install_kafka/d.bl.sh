. $(gbl log)
KAFKA_DOWN_URL="https://downloads.apache.org/kafka/3.3.2/kafka_2.13-3.3.2.tgz"

gblcmd_install_kafka_ub22(){

    if [ -e /etc/systemd/system/zookeeper.service ]; then
        echo "kafka is already installed"
        exit
    fi
    set -e
    sudo apt install default-jre default-jdk -y

    wget "$KAFKA_DOWN_URL" -P ~/ghub
    local k_fname=`basename $KAFKA_DOWN_URL`
    sudo mkdir -p /usr/local/kafka-server && cd /usr/local/kafka-server || exit 0
    sudo tar -xvzf ~/ghub/$k_fname --strip 1
    sudo bash -c 'cat <<EOF1 >"/etc/systemd/system/zookeeper.service"
[Unit]
Description=Apache Zookeeper Server
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
ExecStart=/usr/local/kafka-server/bin/zookeeper-server-start.sh /usr/local/kafka-server/config/zookeeper.properties
ExecStop=/usr/local/kafka-server/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF1'

    sudo bash -c 'cat <<EOF2 >"/etc/systemd/system/kafka.service"
[Unit]
Description=Apache Kafka Server
Documentation=http://kafka.apache.org/documentation.html
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
ExecStart=/usr/local/kafka-server/bin/kafka-server-start.sh /usr/local/kafka-server/config/server.properties
ExecStop=/usr/local/kafka-server/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF2'
    sudo systemctl daemon-reload
    sudo systemctl enable --now zookeeper
    sudo systemctl enable --now kafka
}



gblcmd_uninstall_kafka_ub22() {
  if [ ! -e /etc/systemd/system/zookeeper.service ]; then
      echo "kafka is not installed"
      exit
  fi
  rm -rf ~/ghub/kafka*
  sudo rm -rf /usr/local/kafka-server
  sudo systemctl stop zookeeper
  sudo systemctl stop kafka
  sudo systemctl disable zookeeper
  sudo systemctl disable kafka
  sudo rm  /etc/systemd/system/zookeeper.service
  sudo rm  /etc/systemd/system/kafka.service
}

gblcmd_status(){
    [ -f /etc/systemd/system/kafka.service ] || {
        log "Kafka service not installed"
        return
    }
    log "Kafka service installed"
    systemctl status kafka
}