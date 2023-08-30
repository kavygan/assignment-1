provider "aws" {
  region = "us-east-1" # Update this to your desired region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Update this to your desired availability zone
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a" # Update this to your desired availability zone
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-09301a37d119fe4c5" # Update this with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name    = "AssignmentInstance"
    purpose = "Assignment"
  }
}

resource "aws_security_group" "instance_security_group" {
  name_prefix = "instance_sg_"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


