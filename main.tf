provider "aws" {
  region = "eu-north-1"
  profile = "profile_name"
}
# Define the key pair resource
resource "aws_key_pair" "my_key_pair" {
  key_name = "my-key-pair"  # Name for the key pair
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key file
}

data "external" "my_ip" {
  program = ["bash", "${path.module}/get_ip.sh"]  # Use ["powershell", "${path.module}/get_ip.ps1"] for Windows
}

resource "aws_security_group" "my_sg" {
  name_prefix = "my-security-group-"
  description = "Allow SSH and other ports"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [data.external.my_ip.result["ip"]+"/32"]  # Replace with your IP address or range
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 25
    to_port   = 25
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 465
    to_port   = 465
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5000
    to_port   = 10000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 30000
    to_port   = 32767
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami = "ami-04cdc91e49cb06165"  # Ubuntu AMI ID for your region
  instance_type = "t2.micro"
  key_name = "your-key-pair-name"  # Replace with your key pair name
  tags = {
    Name = "MyUbuntuInstance"
  }

  security_groups = [aws_security_group.my_sg.name]
}

