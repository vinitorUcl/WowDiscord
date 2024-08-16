provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "wow_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 9  # WoL (Wake on LAN) Port
    to_port     = 9
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "wow_sg"
  }
}

resource "aws_instance" "wow_server" {
  ami           = "ami-12345678"  # Substitua pela AMI correta
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = ["${aws_security_group.wow_sg.name}"]

  tags = {
    Name = "Servidor Wake on WAN"
  }
}

resource "aws_instance" "client" {
  ami           = "ami-12345678"  # Substitua pela AMI correta
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = ["${aws_security_group.wow_sg.name}"]

  tags = {
    Name = "Computador Cliente"
  }
}

# Recurso fictício para representação do Bot Discord
resource "null_resource" "discord_bot" {
  provisioner "local-exec" {
    command = "echo 'Bot do Discord configurado'"
  }

  depends_on = [aws_instance.wow_server, aws_instance.client]
}

# Outputs para visualização
output "vpc_id" {
  value = aws_vpc.main.id
}

output "wow_server_ip" {
  value = aws_instance.wow_server.public_ip
}

output "client_ip" {
  value = aws_instance.client.public_ip
}
