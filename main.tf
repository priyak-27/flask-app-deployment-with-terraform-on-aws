
# Define the AWS provider configuration.
provider "aws" {
  region = "us-east-1"  # your desired AWS region.
  access_key = "12345" #enter your aws access_key
  secret_key = "12345" #enter your aws secret_key
}

resource "aws_key_pair" "myawskeypair" {
  key_name   = "Priya-Terraform-Demo"  # name of the key pair
  public_key = file("~/.ssh/id_rsa.pub")  # default location of the public key on local machine
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"  #create a vpc
}

resource "aws_subnet" "test_subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "sec_group" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_instance" "server" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  key_name      = aws_key_pair.myawskeypair.key_name
  vpc_security_group_ids = [aws_security_group.sec_group.id]
  subnet_id              = aws_subnet.test_subnet.id

  tags = {
    Name = "test-server"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"  # username for the EC2 instance
    private_key = file("~/.ssh/id_rsa")  # default location for your private key on your local machine
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to the remote EC2 instance. It will copy my app.py inside /home/ubuntu/ on my instance.
  provisioner "file" {
    source      = "app.py"  # path to your app.py , add full path if it is stored in some other location than main.tf file
    destination = "/home/ubuntu/app.py"  # path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py",
    ]
  }
}







