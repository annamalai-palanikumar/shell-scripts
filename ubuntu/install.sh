#!/bin/bash

# Sample system initial setup commands
# Production ./install.sh jre,mysql,nginx
# Test ./install.sh jre,mysql,nginx
# Build Master ./install.sh jre,jenkins,nginx,git
# Build Slave .install.sh jdk,git,maven

pkgs=($(echo $1 | tr "," "\n"))
for pkg in "${pkgs[@]}"
do
  echo -n "Installing $pkg ..."
  case $pkg in
    jre)
      sudo apt-get install default-jre
      ;;
    jdk)
      sudo apt-get install default-jdk
      ;;
    mysql)
      sudo apt-get install mysql-server
      ;;
    jenkins)
      curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
      sudo apt-get install jenkins
      ;;
    nginx)
      sudo apt-get install certbot python3-certbot-nginx
      sudo apt-get install nginx
      sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT && sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT && sudo netfilter-persistent save
      ;;
    git)
      sudo apt-get install git
      ;;
    maven)
      sudo apt-get install maven
      ;;
    vscode)
      wget -O- https://aka.ms/install-vscode-server/setup.sh | sh
      ;;
    *)
      echo -n "unknown"
      ;;
  esac
done
