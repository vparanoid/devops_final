resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.env}_vpc"
    Env  = var.env
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block              = var.public_subnet
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = var.az

  tags = {
    Name = "${var.env}_subnet_public"
    Env  = var.env
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}_igw"
    Env  = var.env
  }

}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}_default_route_table"
    Env  = var.env
  }

}

resource "aws_security_group" "public_sg" {
  name = "public_sg"
  vpc_id =  aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}_public_sg_ALLOW_SSH_HTTP"
    Env  = var.env
  }

}

