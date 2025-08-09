# PROG8870 Final Project - Terraform Deployment Script
# This script automates the Terraform deployment process

Write-Host "==========================================" -ForegroundColor Green
Write-Host "PROG8870 Final Project - Terraform Deployment" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Set AWS credentials (you can also use aws configure)
$env:AWS_ACCESS_KEY_ID = "YOUR_AWS_ACCESS_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY = "YOUR_AWS_SECRET_ACCESS_KEY"
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "AWS credentials configured" -ForegroundColor Yellow

# Navigate to terraform directory
Set-Location terraform

Write-Host "`nStep 1: Initializing Terraform..." -ForegroundColor Cyan
terraform init

if ($LASTEXITCODE -ne 0) {
    Write-Host "Terraform init failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`nStep 2: Validating Terraform configuration..." -ForegroundColor Cyan
terraform validate

if ($LASTEXITCODE -ne 0) {
    Write-Host "Terraform validation failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`nStep 3: Planning Terraform deployment..." -ForegroundColor Cyan
terraform plan -out=tfplan

if ($LASTEXITCODE -ne 0) {
    Write-Host "Terraform plan failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`nStep 4: Applying Terraform configuration..." -ForegroundColor Cyan
Write-Host "This will create the following resources:" -ForegroundColor Yellow
Write-Host "- 4 Private S3 buckets with versioning" -ForegroundColor White
Write-Host "- VPC with public and private subnets" -ForegroundColor White
Write-Host "- EC2 instance with web server" -ForegroundColor White
Write-Host "- RDS MySQL database" -ForegroundColor White
Write-Host "- Security groups and networking components" -ForegroundColor White

$confirmation = Read-Host "`nDo you want to proceed with the deployment? (y/N)"
if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
    terraform apply tfplan
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n==========================================" -ForegroundColor Green
        Write-Host "Terraform deployment completed successfully!" -ForegroundColor Green
        Write-Host "==========================================" -ForegroundColor Green
        
        Write-Host "`nOutputs:" -ForegroundColor Cyan
        terraform output
        
        Write-Host "`nNext steps:" -ForegroundColor Yellow
        Write-Host "1. Take screenshots of the created resources in AWS Console" -ForegroundColor White
        Write-Host "2. Test the web server by visiting the URL above" -ForegroundColor White
        Write-Host "3. Connect to the EC2 instance using the SSH command above" -ForegroundColor White
        Write-Host "4. Test the RDS database connection" -ForegroundColor White
    } else {
        Write-Host "Terraform deployment failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Deployment cancelled by user" -ForegroundColor Yellow
}

# Clean up plan file
if (Test-Path "tfplan") {
    Remove-Item "tfplan"
}

Write-Host "`nScript completed" -ForegroundColor Green
