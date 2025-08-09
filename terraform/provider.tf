# AWS Provider Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # Backend Configuration for Local State Management
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  
  # Default tags for all resources
  default_tags {
    tags = {
      Project     = "PROG8870-Final-Project"
      Environment = "Development"
      ManagedBy   = "Terraform"
      Owner       = "Student"
    }
  }
}
