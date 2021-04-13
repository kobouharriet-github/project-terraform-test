provider "aws" {
  profile = "MyAWS"
  region = "us-east-1"
}

# Mi VPC
resource "aws_vpc" "my-vpc" {

cidr_block = "10.0.0.0/16"

    tags = {
    Name = "my-vpc"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "my-vpc-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-vpc-igw"
  }
}

#Elastic IP

resource "aws_eip" "eip" {
  vpc = true
}

# Subnet Publica

resource "aws_subnet" "my-subnet-public" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet-public"
  }
}

# Zonas
data "aws_availability_zones" "ave" {
  state = "available"
}

# Subnet Privada
resource "aws_subnet" "my-private-subnet-1a" {
  availability_zone = data.aws_availability_zones.ave.names[0]
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my-private-subnet-1a"
  }
}

resource "aws_subnet" "my-private-subnet-1b" {
  availability_zone = data.aws_availability_zones.ave.names[1]
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "my-private-subnet-1b"
  }
}


#NAT Gateway

resource "aws_nat_gateway" "my-vpc-ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.my-subnet-public.id

  tags = {
    Name = "my-nat-gw"
  }
}

resource "aws_route_table" "my-vpc-public-route" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-vpc-igw.id
  }

  tags = {
    Name = "my-vpc-public-route"
  }
}

resource "aws_default_route_table" "my-vpc-default-route" {
  default_route_table_id = aws_vpc.my-vpc.default_route_table_id

  tags = {
    Name = "my-vpc-default-route"
  }
}


# Asociacion de Tablas
resource "aws_route_table_association" "table" {
  subnet_id      = aws_subnet.my-subnet-public.id
  route_table_id = aws_route_table.my-vpc-public-route.id
}



