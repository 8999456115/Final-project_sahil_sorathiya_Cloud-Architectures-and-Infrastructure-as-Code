# AWS Region
aws_region = "us-east-1"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

# EC2 Configuration
instance_type = "t3.micro"
ami_id = "ami-0c02fb55956c7d316"  # Amazon Linux 2023 in us-east-1
key_name = "prog8870-key"
allowed_ssh_cidr = "0.0.0.0/0"  # WARNING: Change this to your IP for production

# RDS Configuration
db_instance_type = "db.t3.micro"
db_name = "prog8870db"
db_username = "admin"
db_password = "PROG8870SecurePassword123!"  # Change this to a secure password
db_port = 3306

# S3 Bucket Names (make sure these are globally unique)
s3_bucket_names = [
  "prog8870-tf-bucket-1-final-2024",
  "prog8870-tf-bucket-2-final-2024", 
  "prog8870-tf-bucket-3-final-2024",
  "prog8870-tf-bucket-4-final-2024"
]
