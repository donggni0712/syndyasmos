# VPC 생성
resource "aws_vpc" "k8s_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "k8s-vpc"
  }
}

# Subnet 생성
resource "aws_subnet" "k8s_subnet" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true      # Public IP 자동 할당

  tags = {
    Name = "k8s-subnet"
  }
}

# Routing table 생성
resource "aws_route_table" "k8s_rt" {
  vpc_id = aws_vpc.k8s_vpc.id

#   route {
#     cidr_block = "10.0.0.0/16"
#     gateway_id = aws_internet_gateway.k8s_gw.id
#   }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_gw.id
  }

  tags = {
    Name = "k8s-rt"
  }
}

resource "aws_route_table_association" "k8s_rt_assoc" {
  subnet_id      = aws_subnet.k8s_subnet.id
  route_table_id = aws_route_table.k8s_rt.id
}

# Internet Gateway 생성
resource "aws_internet_gateway" "k8s_gw" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    Name = "k8s-gw"
  }
}

# Network ACL 설정
resource "aws_network_acl" "k8s_acl" {
  vpc_id = aws_vpc.k8s_vpc.id
  subnet_ids = [aws_subnet.k8s_subnet.id]

  egress {
    rule_no        = 100
    action         = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
  }

  egress {
    rule_no        = 32766
    action         = "deny"
    cidr_block     = "0.0.0.0/0"
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
  }

  ingress {
    rule_no        = 100
    action         = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
  }

  ingress {
    rule_no        = 32766
    action         = "deny"
    cidr_block     = "0.0.0.0/0"
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
  }

  tags = {
    Name = "k8s-acl"
  }
}

# Security Group 설정
resource "aws_security_group" "k8s_sg" {
  vpc_id = aws_vpc.k8s_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2022
    to_port     = 2022
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-sg"
  }
}
