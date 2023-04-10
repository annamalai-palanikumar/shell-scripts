#!/bin/bash

# Sample system initial setup commands
# Production:
# source <(curl -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jre,mysql,nginx
# Test: 
# source <(curl -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jre,mysql,nginx
# Build Master:
# source <(curl -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jre,jenkins,nginx,git
# Build Slave:
# source <(curl -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jdk,git,maven

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
      sudo usermod --shell /bin/bash zk
      usermod -aG sudo zk
      sudo echo 'DenyUsers zk' >> /etc/ssh/sshd_config
      sudo systemctl restart sshd
      sudo mkdir -p /data/zookeeper
      sudo chown zk:zk /data/zookeeper
      cd /opt
      sudo wget https://www.apache.org/dyn/closer.lua/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz
      sudo tar -xvf apache-zookeeper-3.8.0-bin.tar.gz
      sudo chown zk:zk -R  apache-zookeeper-3.8.0-bin
      sudo ln -s apache-zookeeper-3.8.0-bin zookeeper
      sudo chown -h zk:zk zookeeper
      sudo wget https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/zk.service 
      sudo mv zk.service /etc/systemd/system/zk.service 
      sudo systemctl start zk
      sudo systemctl enable zk
      sudo systemctl status zk
      ;;
    *)
      sudo apt-get -y install $pkg
      ;;
  esac
done
