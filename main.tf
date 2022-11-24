terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
    }
  }
}

# configure the AWS provider

provider "aws" {
  region = "us-east-1"
}

# create a VPC

resource "aws_vpc" "myLab-VPC" {
  cidr_block = var.cidr_block[0]

  tags = {
    Name = "myLab-VPC"
  }
}

# Create Subnet (Public)
resource "aws_subnet" "myLab-Subnet1" {
  vpc_id = aws_vpc.myLab-VPC.id
  cidr_block = var.cidr_block[1]

  tags = {
    Name = "myLab-Subnet1"
  }
}

# Create Internet Gateway

resource "aws_internet_gateway" "myLab-IntGw" {
  vpc_id = aws_vpc.myLab-VPC.id

  tags = {
    Name = "myLab-InternetGw"
  }
}

# Create Security Group

resource "aws_security_group" "myLab_Sec_Group" {
  name = "myLab Security Group"
  description = "To allow inbound and outbound traffic to myLab"
  vpc_id = aws_vpc.myLab-VPC.id

  dynamic ingress {
    iterator = port
    for_each = var.ports
     content {
       from_port = port.value
       to_port = port.value
       protocol = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }
    
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow traffic"
  }
}

# Create route table and association

resource "aws_route_table" "myLab_RouteTable" {
  vpc_id = aws_vpc.myLab-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myLab-IntGw.id
  }

  tags = {
    Name = "myLab_RouteTable"
  }
}

resource "aws_route_table_association" "myLab-Assn" {
  subnet_id = aws_subnet.myLab-Subnet1.id
  route_table_id = aws_route_table.myLab_RouteTable.id
}

# Create an AWS EC2 Instance

resource "aws_instance" "DemoResource" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "EC2"
  vpc_security_group_ids = [aws_security_group.myLab_Sec_Group.id]
  subnet_id = aws_subnet.myLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./installJenkins.sh")

  tags = {
    Name = "Jenkins-Server"
  }
}

# Create an AWS EC" Instance to host Ansible Controller (Control node)

resource "aws_instance" "AnsibleController" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "EC2"
  vpc_security_group_ids = [aws_security_group.myLab_Sec_Group.id]
  subnet_id = aws_subnet.myLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./installAnsible.sh")

  tags = {
    Name = "Ansible-ControlNode"
  }
}
