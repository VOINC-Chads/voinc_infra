provider "aws" {
  region = "us-east-2"  # Change this to the region of your choice
}

resource "aws_instance" "voinc-backend" {
  ami           = "ami-0a695f0d95cefc163"  # Ubuntu 20.04
  instance_type = "t2.small"

  vpc_security_group_ids = ["${aws_security_group.default-sg.id}"]

  key_name               = "voinc"  # voinc key-pair
  associate_public_ip_address = true
  subnet_id = aws_subnet.voinc-subnet.id
  
  # Install Go & Docker, build backend
  user_data = file("user_data.sh")
}

resource "aws_security_group" "default-sg" {
  name_prefix = "default-sg"
  vpc_id     = aws_vpc.voinc-vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a new VPC
resource "aws_vpc" "voinc-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "voinc-vpc"
  }
}

# Create EIP
resource "aws_eip" "voinc-eip" {
  vpc = true
}

# Create a new subnet in the VPC
resource "aws_subnet" "voinc-subnet" {
  vpc_id     = aws_vpc.voinc-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "voinc-subnet"
  }
}

# Create a new route table for the VPC
resource "aws_route_table" "voinc-rt" {
  vpc_id = aws_vpc.voinc-vpc.id

  tags = {
    Name = "voinc-rt"
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "voinc-rta" {
  subnet_id      = aws_subnet.voinc-subnet.id
  route_table_id = aws_route_table.voinc-rt.id
}

# Create a route in the route table that points all traffic to the Internet Gateway
resource "aws_route" "voinc-route" {
  route_table_id         = aws_route_table.voinc-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-voinc.id
}


# Associate the EIP with a network interface
resource "aws_network_interface" "voinc-nic" {
  subnet_id       = aws_subnet.voinc-subnet.id
  security_groups = ["${aws_security_group.default-sg.id}"]
  private_ips     = ["10.0.1.10"]
}

resource "aws_network_interface_attachment" "voinc-attach" {
  instance_id     = aws_instance.voinc-backend.id
  network_interface_id = aws_network_interface.voinc-nic.id
  device_index       = 1

}

# Create internet gateway for VPC
resource "aws_internet_gateway" "igw-voinc" {
  vpc_id = aws_vpc.voinc-vpc.id
}


# Associate the EIP with the instance's network interface
resource "aws_eip_association" "my-eip-association" {
  instance_id   = "${aws_instance.voinc-backend.id}"
  allocation_id = "${aws_eip.voinc-eip.id}"
}