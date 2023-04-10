#!/bin/bash

# Sample system initial setup commands
# Production:
# source <(curl -H 'Cache-Control: no-cache, no-store' -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jre,mysql,nginx,zk
# Test: 
# source <(curl -H 'Cache-Control: no-cache, no-store' -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jre,mysql,nginx,zk
# Build Master:
# source <(curl -H 'Cache-Control: no-cache, no-store' -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jre,jenkins,nginx,git
# Build Slave:
# source <(curl -H 'Cache-Control: no-cache, no-store' -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jdk,git,maven

pkgs=($(echo $1 | tr "," "\n"))
for pkg in "${pkgs[@]}"
do
  echo -n "Installing $pkg ..."
  case $pkg in
    jre)
      sudo apt-get -y install default-jre
      ;;
    jdk)
      sudo apt-get -y install default-jdk
      ;;
    mysql)
      sudo apt-get -y install mysql-server
      ;;
    jenkins)
      curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
      sudo apt-get -y install jenkins
      read -p "Enter Jenkins Domain: " domain
      wget https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/jenkins.example.com
      sed -i 's/jenkins.example.com/$domain/g' jenkins.example.com
      sudo mv jenkins.example.com /etc/nginx/sites-available/${domain}
      sudo ln -sf /etc/nginx/sites-available/${domain} /etc/nginx/sites-enabled/
      ;;
    nginx)
      sudo apt-get -y install certbot python3-certbot-nginx
      sudo apt-get -y install nginx
      sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT && sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT && sudo netfilter-persistent save
      ;;
    git)
      sudo apt-get -y install git
      ;;
    maven)
      sudo apt-get -y install maven
      ;;
    vscode)
      wget -O- https://aka.ms/install-vscode-server/setup.sh | sh
      ;;
    zk)
      sudo useradd zk -m
      id -u zk &>/dev/null || sudo useradd -m zk
      sudo usermod -s /bin/false zk
      sudo mkdir -p /data/zookeeper
      sudo chown zk:zk /data/zookeeper
      cd /opt
      sudo wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz
      sudo tar -xvf apache-zookeeper-3.8.0-bin.tar.gz
      sudo chown zk:zk -R  apache-zookeeper-3.8.0-bin
      sudo ln -s apache-zookeeper-3.8.0-bin zookeeper
      sudo chown -h zk:zk zookeeper
      sudo wget https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/zk.service 
      sudo mv zk.service /etc/systemd/system/zk.service 
      sudo wget https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/zoo.cfg 
      sudo mv zoo.cfg /opt/zookeeper/conf/zoo.cfg 
      sudo systemctl daemon-reload
      sudo systemctl start zk
      sudo systemctl enable zk
      sudo systemctl status zk
      ;;
    zkui)
      sudo useradd zkui -m
      id -u zkui &>/dev/null || sudo useradd -m zkui
      sudo usermod -s /bin/false zkui
      MVN_ALREADY_INSTALLED=1;
      if ! dpkg -s maven; then MVN_ALREADY_INSTALLED=0 & sudo apt -y install maven;fi
      sudo wget -O /opt/master.zip https://github.com/DeemOpen/zkui/archive/refs/heads/master.zip
      sudo unzip -o /opt/master.zip -d /opt/zkui
      sudo rm /opt/master.zip
      sudo mvn clean install -f /opt/zkui/zkui-master/pom.xml
      sudo mv /opt/zkui/zkui-master/target/zkui-2.0-SNAPSHOT-jar-with-dependencies.jar /opt/zkui.jar
      sudo mv /opt/zkui/zkui-master/config.cfg /opt/config.cfg
      sudo rm -d -r /opt/zkui/
      sudo mkdir /opt/zkui/
      sudo mv /opt/zkui.jar /opt/zkui/zkui.jar
      sudo mv /opt/config.cfg /opt/zkui/config.cfg
      if [ $MVN_ALREADY_INSTALLED -eq 0 ]; then sudo apt -y remove --purge maven && sudo apt -y autoremove && sudo rm -d -r ~/.m2 /root/.m2;fi
      sudo chown zkui:zkui -R  /opt/zkui
      sudo wget https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/zkui.service 
      sudo mv zkui.service /etc/systemd/system/zkui.service 
      sudo systemctl daemon-reload
      sudo systemctl start zkui
      sudo systemctl enable zkui
      sudo systemctl status zkui
      ;;
    *)
      sudo apt-get -y install $pkg
      ;;
  esac
done
