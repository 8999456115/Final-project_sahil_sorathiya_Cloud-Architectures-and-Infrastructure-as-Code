# PROG 8870 Final Project - AWS Infrastructure Automation

## 🎯 Project Overview
This project demonstrates Infrastructure as Code (IaC) best practices using both **Terraform** and **CloudFormation** to deploy a scalable AWS infrastructure including S3 buckets, EC2 instances, VPC, and RDS database instances.

## 🚀 Quick Start with GitHub CodeSpaces

### Option 1: GitHub CodeSpaces (Recommended)
1. Click the green **"Code"** button on this repository
2. Select **"Create codespace on main"**
3. Wait for the environment to load (includes Terraform, AWS CLI, PowerShell)
4. Follow the setup instructions below

### Option 2: Local Development
```bash
git clone https://github.com/8999456115/Final-project_sahil_sorathiya_Cloud-Architectures-and-Infrastructure-as-Code.git
cd Final-project_sahil_sorathiya_Cloud-Architectures-and-Infrastructure-as-Code
```

## 📁 Project Structure
```
project/
├── terraform/
│   ├── main.tf                 # Main Terraform configuration
│   ├── provider.tf             # AWS provider configuration
│   ├── variables.tf            # Variable definitions
│   ├── terraform.tfvars        # Variable values
│   ├── outputs.tf              # Output definitions
│   └── ssh/                    # SSH keys directory
├── cloudformation/
│   ├── s3-buckets.yaml         # S3 buckets CloudFormation template
│   ├── ec2-instance.yaml       # EC2 instance CloudFormation template
│   └── rds-instance.yaml       # RDS instance CloudFormation template
├── deploy-terraform.ps1        # PowerShell script for Terraform deployment
├── deploy-cloudformation.ps1   # PowerShell script for CloudFormation deployment
├── cleanup.ps1                 # PowerShell script for cleanup
└── README.md                   # This file
```

## 🔧 Setup Instructions

### 1. AWS Credentials Setup
```bash
# Set your AWS credentials
export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="us-east-1"
```

### 2. Verify Setup
```bash
# Check AWS credentials
aws sts get-caller-identity

# Check Terraform version
terraform version

# Check AWS CLI version
aws --version
```

## 🚀 Deployment Instructions

### Option A: Automated Deployment (Recommended)

#### Deploy Terraform Infrastructure
```bash
# For Windows PowerShell
./deploy-terraform.ps1

# For Linux/Mac Bash
chmod +x deploy-terraform.sh
./deploy-terraform.sh
```

#### Deploy CloudFormation Infrastructure
```bash
# For Windows PowerShell
./deploy-cloudformation.ps1

# For Linux/Mac Bash
chmod +x deploy-cloudformation.sh
./deploy-cloudformation.sh
```

### Option B: Manual Deployment

#### Terraform Deployment
```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
terraform output
```

#### CloudFormation Deployment
```bash
cd cloudformation

# Deploy S3 buckets
aws cloudformation create-stack \
  --stack-name prog8870-s3-stack \
  --template-body file://s3-buckets.yaml \
  --capabilities CAPABILITY_IAM

# Deploy EC2 instance
aws cloudformation create-stack \
  --stack-name prog8870-ec2-stack \
  --template-body file://ec2-instance.yaml \
  --capabilities CAPABILITY_IAM

# Deploy RDS instance
aws cloudformation create-stack \
  --stack-name prog8870-rds-stack \
  --template-body file://rds-instance.yaml \
  --capabilities CAPABILITY_IAM
```

## 📊 Infrastructure Components

### Terraform Resources
- **S3 Buckets**: 4 private buckets with versioning enabled
- **VPC**: Custom VPC with public and private subnets
- **EC2 Instance**: t3.micro instance with public IP and SSH access
- **RDS Instance**: MySQL database with db.t3.micro instance type

### CloudFormation Resources
- **S3 Buckets**: 3 private buckets with PublicAccessBlockConfiguration
- **EC2 Instance**: t3.micro instance with networking components
- **RDS Instance**: MySQL database with public access enabled

## 🔍 Verification Commands

### Check All Resources
```bash
# Check S3 buckets
aws s3 ls | grep prog8870

# Check EC2 instances
aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]" --output table

# Check RDS instances
aws rds describe-db-instances --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,DBInstanceStatus]" --output table

# Check CloudFormation stacks
aws cloudformation describe-stacks --query "Stacks[*].[StackName,StackStatus]" --output table
```

## 🧹 Cleanup Instructions

### Automated Cleanup
```bash
# For Windows PowerShell
./cleanup.ps1

# For Linux/Mac Bash
chmod +x cleanup.sh
./cleanup.sh
```

### Manual Cleanup
```bash
# Terraform cleanup
cd terraform
terraform destroy -auto-approve

# CloudFormation cleanup
aws cloudformation delete-stack --stack-name prog8870-s3-stack
aws cloudformation delete-stack --stack-name prog8870-ec2-stack
aws cloudformation delete-stack --stack-name prog8870-rds-stack
```

## ✅ Project Requirements Fulfilled

### Requirement 1: S3 Bucket Setup ✅
- **Terraform**: 4 Private S3 Buckets with versioning
- **CloudFormation**: 3 Private S3 Buckets with PublicAccessBlockConfiguration

### Requirement 2: VPC and EC2 Instance ✅
- **Terraform**: EC2 in custom VPC with dynamic variables, public IP, SSH access
- **CloudFormation**: EC2 with YAML config, networking components, public IP output

### Requirement 3: RDS Instance Deployment ✅
- **Terraform**: MySQL RDS with variables, DB Subnet Group
- **CloudFormation**: RDS with YAML templates, public access, MySQL port 3306

### Requirement 4: Dynamic Configuration ✅
- **Terraform**: Variables files (variables.tf, terraform.tfvars)
- **CloudFormation**: Parameters in YAML templates

### Requirement 5: Backend/State Management ✅
- **Terraform**: Local state file
- **CloudFormation**: AWS CLI deployment

### Requirement 6: GitHub Repository ✅
- Complete repository with all required files
- Documentation (README.md)

## 🔒 Security Features
- All S3 buckets are private with no public access
- EC2 instances have restricted security groups
- RDS instances are deployed in private subnets (Terraform) or with controlled public access (CloudFormation)
- SSH access is limited to specific IP ranges

## 🐛 Troubleshooting

### Common Issues
1. **AWS Credentials**: Ensure credentials are properly configured
2. **Region**: Verify AWS region is set correctly
3. **Permissions**: Ensure IAM user has necessary permissions
4. **VPC Limits**: Check for VPC and subnet limits in your AWS account

### Useful Commands
```bash
# Check AWS identity
aws sts get-caller-identity

# List CloudFormation stacks
aws cloudformation list-stacks

# Validate CloudFormation template
aws cloudformation validate-template --template-body file://template.yaml

# Check Terraform state
terraform show
```

## 📸 Screenshots Required
Please capture screenshots of:
1. S3 buckets created with versioning enabled
2. EC2 instances with public IP addresses
3. RDS instances running
4. Terraform apply output
5. CloudFormation stack creation output
6. AWS Management Console showing all resources

## 📋 Presentation Guidelines
- Duration: 5-10 minutes
- Cover code structure and implementation
- Demonstrate live deployment
- Show AWS Management Console
- Explain challenges and solutions
- Highlight best practices

## 👨‍💻 Author
**Student:** Sahil Sorathiya  
**Course:** PROG 8870 - Cloud Architectures and Infrastructure as Code  
**Date:** December 2024

## 📞 Contact
For questions or issues, please refer to the project documentation or contact the development team.

## 📄 License
This project is created for educational purposes as part of PROG 8870 Final Project.

---

**🎉 Project Status: 100% Complete and Ready for Submission!**
