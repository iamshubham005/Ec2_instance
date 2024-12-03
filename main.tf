terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}
resource "aws_key_pair" "deployer" {
  key_name   = "id_rsa.pub"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_instance" "my_ec2_instance1" {
  ami           = "ami-0614680123427b75e" 
  instance_type = "t2.micro"
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true 
  tags = {
    Name = "Jenkins-Server"
  }
  provisioner "local-exec" {
    command = "echo ${self.private_ip} > inventory.yaml"
  }
}

output "private_ip" {
  value = aws_instance.my_ec2_instance1.public_ip
}

