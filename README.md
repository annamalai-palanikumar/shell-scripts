# Sample Ubuntu System initial setup commands
## Production:
  `source <(curl -H 'Cache-Control: no-cache, no-store' -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jre,mysql,nginx`
## Test: 
  `source <(curl -H 'Cache-Control: no-cache, no-store' -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jre,mysql,nginx`
## Build Master:
  `source <(curl -H 'Cache-Control: no-cache, no-store' -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jre,jenkins,nginx,git`
## Build Slave:
  `source <(curl -H 'Cache-Control: no-cache, no-store' -s https://raw.githubusercontent.com/annamalai-palanikumar/shell-scripts/main/ubuntu/install.sh) jdk,git,maven`

## List of package installation commands:
- jre - `sudo apt-get install default-jre`
- jdk - `sudo apt-get install default-jdk`
- mysql - `sudo apt-get install mysql-server`
- git - `sudo apt-get install git`
- maven - `sudo apt-get install maven`
- nginx - `sudo apt-get install nginx certbot python3-certbot-nginx`
- jenkins - `curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null && echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null && sudo apt-get install jenkins`
