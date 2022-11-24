#! /bin/bash

# Update SO
sudo yum update -y

# install ansible
sudo amazon-linux-extras install ansible2 -y
ansible --version

# Create user ansible admin

sudo su -
# add the user ansible admin
sudo useradd ansibleadmin
# set password : the below commando will avoid re entering the password
sudo echo "ansibleadminad@" | passwd --stdin ansibleadmin
# modify the sudoers file at /etc/sudoers and add entry
echo 'ansibleadmin  ALL=(ALL)   NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo 'ec2-user  ALL=(ALL)   NOPASSWD: ALL' | sudo tee -a /etc/sudoers
# this command is to add an entry to file : echo 'PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config
# the below sed commando will find and replace words with spaces "PasswordAuthentication no" to "PasswordAuthentication"
# sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication tes/g' /etc/ssh/sshd_config
# sudo service sshd restart