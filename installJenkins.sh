#! /bin/bash

# Update SO
sudo yum update -y

 # Install Docker
# sudo yum install -y yum-utils
# sudo yum-config-manager \
#     --add-repo \
#     https://download.docker.com/linux/centos/docker-ce.repo

# sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
# sudo systemctl start docker
# sudo systemctl enabled docker

# Install docker compose
# sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose




# Install Jenkins ==> https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/#step1-security-group

# Add the Jenkins repo using the following command:
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import a key file from Jenkins-CI to enable installation from the package:
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade

# Install Java:
sudo amazon-linux-extras install java-openjdk11 -y

# Install Jenkins:
sudo yum install jenkins -y

# Enable the Jenkins service to start at boot:
sudo systemctl enable jenkins

# Start Jenkins as a service:
sudo systemctl start jenkins

# You can check the status of the Jenkins service using the command:
# sudo systemctl status jenkins