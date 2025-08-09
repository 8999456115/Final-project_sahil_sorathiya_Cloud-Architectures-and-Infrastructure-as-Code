# AWS Infrastructure Automation with Terraform and CloudFormation

## Project Overview
This project demonstrates Infrastructure as Code (IaC) best practices using both Terraform and CloudFormation to deploy a scalable AWS infrastructure. The infrastructure includes S3 buckets, EC2 instances, VPC, and RDS database instances.

## Project Structure
```
project/
├── terraform/
│   ├── main.tf                 # Main Terraform configuration
│   ├── provider.tf             # AWS provider configuration
│   ├── variables.tf            # Variable definitions
│   ├── terraform.tfvars        # Variable values (DO NOT commit sensitive data)
│   ├── backend.tf              # Backend configuration
│   └── outputs.tf              # Output definitions
├── cloudformation/
│   ├── s3-buckets.yaml         # S3 buckets CloudFormation template
│   ├── ec2-instance.yaml       # EC2 instance CloudFormation template
│   └── rds-instance.yaml       # RDS instance CloudFormation template
├── screenshots/                 # Screenshots for documentation
└── README.md                   # This file
```

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed (version >= 1.0)
- Git for version control

## AWS Credentials Setup
Configure your AWS credentials using one of these methods:

### Method 1: AWS CLI
```bash
aws configure
```
Enter your Access Key ID and Secret Access Key when prompted.

### Method 2: Environment Variables
```bash
export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="us-east-1"
```

## Terraform Deployment

### 1. Initialize Terraform
```bash
cd terraform
terraform init
```

### 2. Review the Plan
```bash
terraform plan
```

### 3. Apply the Configuration
```bash
terraform apply
```

### 4. Destroy Resources (when done)
```bash
terraform destroy
```

## CloudFormation Deployment

### 1. Deploy S3 Buckets
```bash
aws cloudformation create-stack \
  --stack-name s3-buckets-stack \
  --template-body file://cloudformation/s3-buckets.yaml \
  --capabilities CAPABILITY_IAM
```

### 2. Deploy EC2 Instance
```bash
aws cloudformation create-stack \
  --stack-name ec2-instance-stack \
  --template-body file://cloudformation/ec2-instance.yaml \
  --capabilities CAPABILITY_IAM
```

### 3. Deploy RDS Instance
```bash
aws cloudformation create-stack \
  --stack-name rds-instance-stack \
  --template-body file://cloudformation/rds-instance.yaml \
  --capabilities CAPABILITY_IAM
```

### 4. Monitor Stack Status
```bash
aws cloudformation describe-stacks --stack-name <stack-name>
```

### 5. Delete Stacks (when done)
```bash
aws cloudformation delete-stack --stack-name <stack-name>
```

## Infrastructure Components

### Terraform Resources
- **S3 Buckets**: 4 private buckets with versioning enabled
- **VPC**: Custom VPC with public and private subnets
- **EC2 Instance**: t3.micro instance with public IP and SSH access
- **RDS Instance**: MySQL database with db.t3.micro instance type

### CloudFormation Resources
- **S3 Buckets**: 3 private buckets with PublicAccessBlockConfiguration
- **EC2 Instance**: t3.micro instance with networking components
- **RDS Instance**: MySQL database with public access enabled

## Security Features
- All S3 buckets are private with no public access
- EC2 instances have restricted security groups
- RDS instances are deployed in private subnets (Terraform) or with controlled public access (CloudFormation)
- SSH access is limited to specific IP ranges

## Best Practices Implemented
- **Modularity**: Separate files for different resource types
- **Variables**: Dynamic configuration using variables and tfvars
- **Backend**: Local state management
- **Documentation**: Comprehensive README and code comments
- **Security**: Proper IAM roles and security groups
- **Versioning**: S3 bucket versioning enabled

## Troubleshooting

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
```

## Screenshots Required
Please capture screenshots of:
1. S3 buckets created with versioning enabled
2. EC2 instances with public IP addresses
3. RDS instances running
4. Terraform apply output
5. CloudFormation stack creation output
6. AWS Management Console showing all resources

## Presentation Guidelines
- Duration: 5-10 minutes
- Cover code structure and implementation
- Demonstrate live deployment
- Show AWS Management Console
- Explain challenges and solutions
- Highlight best practices

## Contact
For questions or issues, please refer to the project documentation or contact the development team.

## License
This project is created for educational purposes as part of PROG 8870 Final Project.
