
# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/16"
# Must be enabled for EFS
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ub-vpc"
  }
}

# create a elastic ip
resource "aws_eip" "nat-eip" {
  domain = "vpc"
}

# Create a public subnet
resource "aws_subnet" "pub-subnet-01" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.0.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-subnet-01"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Create a public subnet
resource "aws_subnet" "pub-subnet-02" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.16.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-subnet-02"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}


# Create a private subnet
resource "aws_subnet" "pri-subnet-01" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.32.0/24"
  availability_zone       = "ap-northeast-2a"
  tags = {
    Name = "pri-subnet-01"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Create a private subnet
resource "aws_subnet" "pri-subnet-02" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.48.0/24"
  availability_zone       = "ap-northeast-2c"
  tags = {
    Name = "pri-subnet-02"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Create a private subnet
resource "aws_subnet" "pri-subnet-03" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.64.0/24"
  availability_zone       = "ap-northeast-2a"
  tags = {
    Name = "pri-subnet-03"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Create a private subnet
resource "aws_subnet" "pri-subnet-04" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.80.0/24"
  availability_zone       = "ap-northeast-2c"
  tags = {
    Name = "pri-subnet-04"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

#nat gateway
resource "aws_nat_gateway" "my-ngw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.pub-subnet-01.id

  tags = {
    Name = "my-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my_igw] # igw가 생성된 후에 nat gateway가 생성되도록 함
}


# Create a route table
resource "aws_route_table" "my_rtb-pub-01" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_rtb-pub-01"
  }
}

resource "aws_route_table" "my_rtb-pub-02" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_rtb-pub-02"
  }
}

resource "aws_route_table" "my_rtb-pri-01" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_rtb-pri-01"
  }
}

resource "aws_route_table" "my_rtb-pri-02" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_rtb-pri-02"
  }
}

resource "aws_route_table" "my_rtb-pri-03" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_rtb-pri-03"
  }
}

resource "aws_route_table" "my_rtb-pri-04" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_rtb-pri-04"
  }
}


# Create a route in the rtb-pub-01 
resource "aws_route" "my_route-pub-01" {
  route_table_id         = aws_route_table.my_rtb-pub-01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create a route in the rtb-pub-02
resource "aws_route" "my_route-pub-02" {
  route_table_id         = aws_route_table.my_rtb-pub-02.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create a route in the rtb-pri-01 
resource "aws_route" "my_route-pri-01" {
  route_table_id         = aws_route_table.my_rtb-pri-01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.my-ngw.id
}

# Create a route in the rtb-pri-02 
resource "aws_route" "my_route-pri-02" {
  route_table_id         = aws_route_table.my_rtb-pri-02.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.my-ngw.id
}

# Create a route in the rtb-pri-03
resource "aws_route" "my_route-pri-03" {
  route_table_id         = aws_route_table.my_rtb-pri-03.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.my-ngw.id
}

# Create a route in the rtb-pri-04
resource "aws_route" "my_route-pri-04" {
  route_table_id         = aws_route_table.my_rtb-pri-04.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.my-ngw.id
}


# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_association-pub-01" {
  subnet_id      = aws_subnet.pub-subnet-01.id
  route_table_id = aws_route_table.my_rtb-pub-01.id
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_association-pub-02" {
  subnet_id      = aws_subnet.pub-subnet-02.id
  route_table_id = aws_route_table.my_rtb-pub-02.id
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_association-pri-01" {
  subnet_id      = aws_subnet.pri-subnet-01.id
  route_table_id = aws_route_table.my_rtb-pri-01.id
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_association-pri-02" {
  subnet_id      = aws_subnet.pri-subnet-02.id
  route_table_id = aws_route_table.my_rtb-pri-02.id
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_association-pri-03" {
  subnet_id      = aws_subnet.pri-subnet-03.id
  route_table_id = aws_route_table.my_rtb-pri-03.id
}
# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_association-pri-04" {
  subnet_id      = aws_subnet.pri-subnet-04.id
  route_table_id = aws_route_table.my_rtb-pri-04.id
}



terraform {
 backend "s3" {
 # Replace this with your bucket name!
 bucket = "terraform-state-ubariall-2024"
 key = "stage/data-stores/ubariall/terraform.tfstate"
 region = "ap-northeast-2"
 # Replace this with your DynamoDB table name!
 dynamodb_table = "terraform-ub-locks"
 encrypt = true
 }
}
