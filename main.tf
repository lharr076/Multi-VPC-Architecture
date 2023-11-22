module "vpc_a" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc_a"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "vpc_b" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc_b"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.1.0.0/24", "10.1.1.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "vpc_c" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc_c"
  cidr = "10.2.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.2.0.0/24", "10.2.1.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
 


# Create Internet Gateway A
resource "aws_internet_gateway" "igw-a" {
  vpc_id = "${vpc_a.id}"

  tags = {
    Name = "IGW A"
  }

}

# Create Internet Gateway B
resource "aws_internet_gateway" "igw-b" {
  vpc_id = "${vpc_b.id}"

  tags = {
    Name = "IGW B"
  }

}

# Create Internet Gateway C
resource "aws_internet_gateway" "igw-c" {
  vpc_id = "${vpc_c.id}"

  tags = {
    Name = "IGW C"
  }

}

# Create Route Table A
resource "aws_route_table" "route-table-a" {
  vpc_id = "${vpc_a.id}"
  
}

# Create Route Table B
resource "aws_route_table" "route-table-b" {
  vpc_id = "${vpc_b.id}"
  
}

# Create Route Table C
resource "aws_route_table" "route-table-c" {
  vpc_id = "${vpc_c.id}"
  
}

# Create Route to IGW in Route Table A
resource "aws_route" "internet-a" {
  route_table_id         = "${aws_route_table.route-table-a.id}"
  destination_cidr_block = "10.0.0.0/16" # Replace with your VPC CIDR block
  gateway_id       = "${aws_internet_gateway.igw-a.id}"
}

# Create Route to IGW in Route Table B
resource "aws_route" "internet-b" {
  route_table_id         = "${aws_route_table.route-table-b.id}"
  destination_cidr_block = "10.1.0.0/16" # Replace with your VPC CIDR block
  gateway_id       = "${aws_internet_gateway.igw-b.id}"
}

# Create Route to IGW in Route Table C
resource "aws_route" "internet-c" {
  route_table_id         = "${aws_route_table.route-table-c.id}"
  destination_cidr_block = "10.2.0.0/16" # Replace with your VPC CIDR block
  gateway_id       = "${aws_internet_gateway.igw-c.id}"
}

# Create Security Group for VPC A
resource "aws_security_group" "vpc-a-security-group" {
  name_prefix = "VPC A EC2 Security Group"
  description = "Allow ICMP Traffic"
  vpc_id = "${vpc_a.id}"

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
  vpc_id = "${vpc_b.id}"


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
  vpc_id = "${vpc_c.id}"


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
  ami = "ami-0fa1ca9559f1892ec"
  instance_type = "t2.micro"
  



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
  ami = "ami-0fa1ca9559f1892ec" 
  instance_type = "t2.micro"
  

  

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
  ami = "ami-0fa1ca9559f1892ec"
  instance_type = "t2.micro"
  



  security_groups = ["${aws_security_group.vpc-c-security-group.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30 # Specify the desired size in GB
  }

  tags = { 
    Name = "EC2 VPC C - AZ1"
  }

}
