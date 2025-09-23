provider "aws" {
  region = "ap-south-1"  # Mumbai region
}

# ----------- Generate SSH Key Pair -----------

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# ----------- Save the Private Key to a Regular Directory -----------

resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "/home/ubuntu/keys/my-new-key.pem"  # Save private key in /home/ubuntu/keys/
}

# ----------- Create AWS Key Pair -----------

resource "aws_key_pair" "key" {
  key_name   = "my-new-key"  # Specify a new key name
  public_key = tls_private_key.example.public_key_openssh  # Public key from the private key created above
}

# ----------- VPC Configuration -----------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyDefault-VPC"
  }
}

# ----------- Subnet Configuration -----------
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "MyDefault-Subnet"
  }
}

# ----------- Internet Gateway Configuration -----------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MyDefault-IGW"
  }
}

# ----------- Route Table Configuration -----------
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "MyDefault-RTB"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rtb.id
}

# ----------- Security Group Configuration -----------
resource "aws_security_group" "sg" {
  name        = "MyDefault-sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MyDefault-sg"
  }
}

# ----------- Fetch Latest Ubuntu AMI -----------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's Owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# ----------- EC2 Instance Configuration -----------
resource "aws_instance" "ec2" {
  count                       = 1  # EC2 Count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]  # Corrected here
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "MyDefault-EC2-${count.index + 1}"
  }
}

# ----------- Outputs -----------
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "route_table_id" {
  value = aws_route_table.rtb.id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

output "key_name" {
  value = aws_key_pair.key.key_name
}

output "instance_ids" {
  value = aws_instance.ec2[*].id
}

output "public_ips" {
  value = aws_instance.ec2[*].public_ip
}