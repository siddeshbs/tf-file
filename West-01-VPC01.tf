provider "aws" {
  region     = var.region
  access_key = "________"
  secret_key = "_____"
}

#VPC01
resource "aws_vpc" "Test-VPC01" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Dev-Test-VPC01"
  }
}

#INternet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.Test-VPC01.id

  tags = {
    Name = "TestVPC01IGW"
  }
}

#NAT Gateway
resource "aws_nat_gateway" "NATgw" {
  allocation_id = "eipalloc-71736042"
  subnet_id     = aws_subnet.Pub_Sub_01.id
}


#Private subnet
resource "aws_subnet" "Pri_Sub_01" {
  vpc_id     = aws_vpc.Test-VPC01.id
  cidr_block = "10.141.1.0/26"
  availability_zone = "us-west-1a"

  tags = {
    Name = "Pri_Sub_01_Test-VPC01"
  }
}
resource "aws_subnet" "Pri_Sub_02" {
  vpc_id     = aws_vpc.Test-VPC01.id
  cidr_block = "10.141.1.64/26"
  availability_zone = "us-west-1b"

  tags = {
    Name = "Pri_Sub_02_Test-VPC01"
  }
}

#Public subnet
resource "aws_subnet" "Pub_Sub_01" {
  vpc_id     = aws_vpc.Test-VPC01.id
  cidr_block = "10.141.2.0/26"



  availability_zone = "us-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub_Sub_01_Test-VPC01"
  }
}
resource "aws_subnet" "Pub_Sub_02" {
  vpc_id     = aws_vpc.Test-VPC01.id
  cidr_block = "10.141.2.64/26"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub_Sub_02_Test-VPC01"
  }
}

resource "aws_subnet" "Pub_Sub_03" {
  vpc_id     = aws_vpc.Test-VPC01.id
  cidr_block = "10.141.2.128/26"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub_Sub_03_Test-VPC01"
  }
}

# Private Route Table
resource "aws_route_table" "PrivateRouteTable" {
  vpc_id     = aws_vpc.Test-VPC01.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }

    tags = {
    Name = "Pri_RT_Test-VPC01"
  }
}

# Public Route Table
resource "aws_route_table" "PublicRouteTable" {
  vpc_id     = aws_vpc.Test-VPC01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

    tags = {
    Name = "Pub_RT_Test-VPC01"
  }
}

#Route association in Private route Table
resource "aws_route_table_association" "PrivateRouteTable" {
    subnet_id      = aws_subnet.Pri_Sub_01.id
    route_table_id = aws_route_table.PrivateRouteTable.id
}

#Route association in Public  route Table
resource "aws_route_table_association" "PublicRouteTable" {
    subnet_id      = aws_subnet.Pub_Sub_01.id
    route_table_id = aws_route_table.PublicRouteTable.id
}
