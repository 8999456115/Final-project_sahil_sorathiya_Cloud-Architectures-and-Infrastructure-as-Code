# =============================================================================
# S3 BUCKETS (4 Private Buckets with Versioning)
# =============================================================================

# Create 4 private S3 buckets with versioning enabled
resource "aws_s3_bucket" "private_buckets" {
  count  = length(var.s3_bucket_names)
  bucket = var.s3_bucket_names[count.index]
  
  tags = merge(var.common_tags, {
    Name = "Private Bucket ${count.index + 1}"
    Purpose = "PROG8870 Project Storage"
  })
}

# Enable versioning on all buckets (Bonus Challenge)
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  count  = length(aws_s3_bucket.private_buckets)
  bucket = aws_s3_bucket.private_buckets[count.index].id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access on all buckets
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  count  = length(aws_s3_bucket.private_buckets)
  bucket = aws_s3_bucket.private_buckets[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# =============================================================================
# VPC AND NETWORKING
# =============================================================================

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "PROG8870-VPC"
  })
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "PROG8870-IGW"
  })
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "Public Subnet ${count.index + 1}"
    Type = "Public"
  })
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.common_tags, {
    Name = "Private Subnet ${count.index + 1}"
    Type = "Private"
  })
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "Public Route Table"
  })
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# =============================================================================
# SECURITY GROUPS
# =============================================================================

# Security Group for EC2 Instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main.id

  # SSH access
  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # HTTP access
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "EC2 Security Group"
  })
}

# Security Group for RDS Instance
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  # MySQL access from EC2
  ingress {
    description     = "MySQL from EC2"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tags = merge(var.common_tags, {
    Name = "RDS Security Group"
  })
}

# =============================================================================
# EC2 INSTANCE
# =============================================================================

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create EC2 Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("${path.module}/ssh/prog8870-key.pub")
}

# Create EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.public[0].id
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from PROG8870 Final Project!</h1>" > /var/www/html/index.html
              echo "<p>This server was deployed using Terraform</p>" >> /var/www/html/index.html
              echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
              EOF

  tags = merge(var.common_tags, {
    Name = "PROG8870-WebServer"
  })
}

# =============================================================================
# RDS DATABASE
# =============================================================================

# Create DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "prog8870-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = merge(var.common_tags, {
    Name = "PROG8870 DB Subnet Group"
  })
}

# Create RDS Instance
resource "aws_db_instance" "main" {
  identifier = "prog8870-db"

  engine         = "mysql"
  instance_class = var.db_instance_type

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  skip_final_snapshot = true
  deletion_protection = false

  tags = merge(var.common_tags, {
    Name = "PROG8870-RDS-MySQL"
  })
}
