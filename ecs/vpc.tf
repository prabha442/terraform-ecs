# network.tf

resource "aws_vpc" "test-vpc" {
  cidr_block = "10.10.0.0/16"
  
   tags = {
    Name        = "${var.app_name}-vpc"
    Environment = var.app_environment
  }
}

# Fetch AZs in the current region
#data "aws_availability_zones" "available" {
#}


# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  vpc_id            = aws_vpc.test-vpc.id
  
  tags = {
    Name        = "${var.app_name}-private-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.test-vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
  
  tags = {
    Name        = "${var.app_name}-igw"
    Environment = var.app_environment
  }

}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.test-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.test-igw.id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "test-eip" {
  count      = length(var.private_subnets)
  vpc        = true
  depends_on = [aws_internet_gateway.test-igw]
}

resource "aws_nat_gateway" "test-natgw" {
  count         = length(var.public_subnets)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.test-eip.*.id, count.index)
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.test-natgw.*.id, count.index)
    #nat_gateway_id = aws_nat_gateway.test-natgw.*.id
  
  }
  
  tags = {
    Name        = "${var.app_name}-routing-table-private"
    Environment = var.app_environment
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
