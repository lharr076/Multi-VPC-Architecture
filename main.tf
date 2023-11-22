# Create VPC A
resource "aws_vpc" "vpc_a" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC A"
  }
}

  # Create VPC B
resource "aws_vpc" "vpc_b" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC B"
  }

}
  # Create VPC C
resource "aws_vpc" "vpc_c" {
  cidr_block = "10.2.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC C"
  }

}

# Create Private Subnet A AZ1
resource "aws_subnet" "private_subnet_A_AZ1" {
  vpc_id = "${aws_vpc.vpc_a.id}"
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Private Subnet A AZ1"
  }

}

# Create Private Subnet A AZ2
resource "aws_subnet" "private_subnet_A_AZ2" {
  vpc_id = "${aws_vpc.vpc_a.id}"
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Private Subnet A AZ2"
  }

}

# Create Private Subnet B AZ1
resource "aws_subnet" "private_subnet_B_AZ1" {
  vpc_id = "${aws_vpc.vpc_b.id}"
  cidr_block = "10.1.0.0/24"

  tags = {
    Name = "Private Subnet B AZ1"
  }

}

# Create Private Subnet B AZ2
resource "aws_subnet" "private_subnet_B_AZ2" {
  vpc_id = "${aws_vpc.vpc_b.id}"
  cidr_block = "10.1.0.0/24"

  tags = {
    Name = "Private Subnet B AZ2"
  }

}

# Create Private Subnet C AZ1
resource "aws_subnet" "private_subnet_C_AZ1" {
  vpc_id = "${aws_vpc.vpc_c.id}"
  cidr_block = "10.2.0.0/24"

  tags = {
    Name = "Private Subnet C AZ1"
  }

}

# Create Private Subnet C AZ2
resource "aws_subnet" "private_subnet_C_AZ2" {
  vpc_id = "${aws_vpc.vpc_c.id}"
  cidr_block = "10.2.0.0/24"

  tags = {
    Name = "Private Subnet C AZ2"
  }

}

# Create Internet Gateway A
resource "aws_internet_gateway" "igw-a" {
  vpc_id = "${aws_vpc.vpc_a.id}"

  tags = {
    Name = "IGW A"
  }

}

# Create Internet Gateway B
resource "aws_internet_gateway" "igw-b" {
  vpc_id = "${aws_vpc.vpc_b.id}"

  tags = {
    Name = "IGW B"
  }

}

# Create Internet Gateway C
resource "aws_internet_gateway" "igw-c" {
  vpc_id = "${aws_vpc.vpc_c.id}"

  tags = {
    Name = "IGW C"
  }

}

# Create Route Table A
resource "aws_route_table" "route-table-a" {
  vpc_id = "${aws_vpc.vpc_a.id}"
  
}

# Create Route Table B
resource "aws_route_table" "route-table-b" {
  vpc_id = "${aws_vpc.vpc_b.id}"
  
}

# Create Route Table C
resource "aws_route_table" "route-table-c" {
  vpc_id = "${aws_vpc.vpc_c.id}"
  
}

# Create Route to IGW in Route Table A
resource "aws_route" "internet-a" {
  route_table_id         = "${aws_route_table.route-table-a.id}"
  destination_cidr_block = "10.0.0.0/24" # Replace with your VPC CIDR block
  gateway_id       = "${aws_internet_gateway.igw-a.id}"
}

# Create Route to IGW in Route Table B
resource "aws_route" "internet-b" {
  route_table_id         = "${aws_route_table.route-table-b.id}"
  destination_cidr_block = "10.1.0.0/24" # Replace with your VPC CIDR block
  gateway_id       = "${aws_internet_gateway.igw-b.id}"
}

# Create Route to IGW in Route Table C
resource "aws_route" "internet-c" {
  route_table_id         = "${aws_route_table.route-table-c.id}"
  destination_cidr_block = "10.2.0.0/24" # Replace with your VPC CIDR block
  gateway_id       = "${aws_internet_gateway.igw-c.id}"
}

# Create Security Group for VPC A
resource "aws_security_group" "vpc-a-security-group" {
  name_prefix = "VPC A EC2 Security Group"
  description = "Allow ICMP Traffic"
  vpc_id = "${aws_vpc.vpc_a.id}"

  ingress {
    from_port   = -1  # ICMP type and code (-1 means all)
    to_port     = -1  # ICMP type and code (-1 means all)
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

    tags = {
    Name = "VPC A EC2 Security Group"
  }

}

# Create Security Group for VPC B
resource "aws_security_group" "vpc-b-security-group" {
  name_prefix = "VPC B EC2 Security Group"
  description = "Allow ICMP Traffic"
  vpc_id = "${aws_vpc.vpc_b.id}"


  ingress {
    from_port   = -1  # ICMP type and code (-1 means all)
    to_port     = -1  # ICMP type and code (-1 means all)
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }


    tags = {
    Name = "VPC B EC2 Security Group"
  }

}

# Create Security Group for VPC C
resource "aws_security_group" "vpc-c-security-group" {
  name_prefix = "VPC C EC2 Security Group"
  description = "Allow ICMP Traffic"
  vpc_id = "${aws_vpc.vpc_c.id}"


  ingress {
    from_port   = -1  # ICMP type and code (-1 means all)
    to_port     = -1  # ICMP type and code (-1 means all)
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }


    tags = {
    Name = "VPC C EC2 Security Group"
  }

}

# Create VPC A Instance.
resource "aws_instance" "EC2_A" {
  ami = "ami-09f85f3aaae282910"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private_subnet_A_AZ1.id}"



  security_groups = ["${aws_security_group.vpc-a-security-group.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30 # Specify the desired size in GB
  }

  tags = { 
    Name = "EC2 VPC A - AZ1"
  }

}

# Crate VPC B Instance.
resource "aws_instance" "EC2_B" {
  ami = "ami-09f85f3aaae282910" 
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private_subnet_B_AZ1.id}"

  

  security_groups = ["${aws_security_group.vpc-b-security-group.id}"]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 12 # Specify the desired size in GB
  }

  tags = { 
    Name = "EC2 VPC B - AZ1"
  }

}

# Create VPC C Instance.
resource "aws_instance" "EC2_C" {
  ami = "ami-09f85f3aaae282910"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private_subnet_C_AZ1.id}"



  security_groups = ["${aws_security_group.vpc-c-security-group.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30 # Specify the desired size in GB
  }

  tags = { 
    Name = "EC2 VPC C - AZ1"
  }

}
