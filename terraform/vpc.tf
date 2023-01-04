# VPC
resource "aws_vpc" "assignment" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                           = "${var.project}-vpc",
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet_numbers  
  vpc_id            = aws_vpc.assignment.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value)
  availability_zone = each.key
  map_public_ip_on_launch = true
  tags = {
    Name                                           = "${var.project}-public-subnet-${each.key}"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = 1
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnet_numbers 
  vpc_id            = aws_vpc.assignment.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value)
  availability_zone = each.key
  tags = {
    Name                                           = "${var.project}-private-subnet-${each.key}"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"              = 1
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.assignment.id
  depends_on = [aws_vpc.assignment]
  tags = {
    "Name" = "${var.project}-igw"
  }
}

# NAT Elastic IP
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "${var.project}-ngw-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "${var.project}-ngw"
  }
}

# Route Table(s)
# Route the public subnet traffic through the IGW
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.assignment.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project}-public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.assignment.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.project}-private-route-table"
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "public_route_table_association" {
  for_each       = var.public_subnet_numbers
  subnet_id      = aws_subnet.public_subnet["${each.key}"].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each       = var.private_subnet_numbers
  subnet_id      = aws_subnet.private_subnet["${each.key}"].id
  route_table_id = aws_route_table.private_route_table.id
}