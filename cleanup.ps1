
# PROG8870 Final Project - Cleanup Script
# This script destroys all resources created by Terraform and CloudFormation

Write-Host "==========================================" -ForegroundColor Red
Write-Host "PROG8870 Final Project - Resource Cleanup" -ForegroundColor Red
Write-Host "==========================================" -ForegroundColor Red

# Set AWS credentials
$env:AWS_ACCESS_KEY_ID = "YOUR_AWS_ACCESS_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY = "YOUR_AWS_SECRET_ACCESS_KEY"
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "AWS credentials configured" -ForegroundColor Yellow

Write-Host "`nWARNING: This will destroy ALL resources created for this project!" -ForegroundColor Red
Write-Host "This includes:" -ForegroundColor Yellow
Write-Host "- S3 buckets and all their contents" -ForegroundColor White
Write-Host "- EC2 instances" -ForegroundColor White
Write-Host "- RDS databases" -ForegroundColor White
Write-Host "- VPCs, subnets, and networking components" -ForegroundColor White
Write-Host "- Security groups" -ForegroundColor White

$confirmation = Read-Host "`nAre you sure you want to proceed? Type 'DESTROY' to confirm"
if ($confirmation -ne 'DESTROY') {
    Write-Host "Cleanup cancelled by user" -ForegroundColor Yellow
    exit 0
}

# Cleanup CloudFormation Stacks
Write-Host "`nStep 1: Cleaning up CloudFormation stacks..." -ForegroundColor Cyan

$stacks = @(
    "prog8870-rds-instance-stack",
    "prog8870-ec2-instance-stack", 
    "prog8870-s3-buckets-stack"
)

foreach ($stack in $stacks) {
    Write-Host "Deleting stack: $stack" -ForegroundColor Yellow
    
    # Check if stack exists
    $stackExists = aws cloudformation describe-stacks --stack-name $stack 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        aws cloudformation delete-stack --stack-name $stack
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Waiting for stack $stack to be deleted..." -ForegroundColor Yellow
            aws cloudformation wait stack-delete-complete --stack-name $stack
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Stack $stack deleted successfully" -ForegroundColor Green
            } else {
                Write-Host "Failed to delete stack $stack" -ForegroundColor Red
            }
        } else {
            Write-Host "Failed to initiate deletion of stack $stack" -ForegroundColor Red
        }
    } else {
        Write-Host "Stack $stack does not exist, skipping..." -ForegroundColor Yellow
    }
}

# Cleanup Terraform Resources
Write-Host "`nStep 2: Cleaning up Terraform resources..." -ForegroundColor Cyan

Set-Location terraform

# Check if terraform is initialized
if (Test-Path ".terraform") {
    Write-Host "Destroying Terraform resources..." -ForegroundColor Yellow
    
    terraform destroy -auto-approve
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Terraform resources destroyed successfully" -ForegroundColor Green
    } else {
        Write-Host "Failed to destroy Terraform resources" -ForegroundColor Red
    }
} else {
    Write-Host "Terraform not initialized, skipping..." -ForegroundColor Yellow
}

# Return to root directory
Set-Location ..

# Cleanup local files
Write-Host "`nStep 3: Cleaning up local files..." -ForegroundColor Cyan

$filesToRemove = @(
    "terraform/.terraform",
    "terraform/.terraform.lock.hcl",
    "terraform/terraform.tfstate",
    "terraform/terraform.tfstate.backup",
    "terraform/tfplan"
)

foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        Remove-Item $file -Recurse -Force
        Write-Host "Removed: $file" -ForegroundColor Green
    }
}

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "Cleanup completed!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

Write-Host "`nNote: Some resources may take a few minutes to be fully deleted from AWS." -ForegroundColor Yellow
Write-Host "You can check the AWS Console to verify all resources have been removed." -ForegroundColor Yellow
