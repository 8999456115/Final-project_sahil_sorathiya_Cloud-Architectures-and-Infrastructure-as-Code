# PROG8870 Final Project - CloudFormation Deployment Script
# This script automates the CloudFormation deployment process

Write-Host "==========================================" -ForegroundColor Green
Write-Host "PROG8870 Final Project - CloudFormation Deployment" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Set AWS credentials (you can also use aws configure)
$env:AWS_ACCESS_KEY_ID = "YOUR_AWS_ACCESS_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY = "YOUR_AWS_SECRET_ACCESS_KEY"
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "AWS credentials configured" -ForegroundColor Yellow

# Function to deploy CloudFormation stack
function Deploy-CloudFormationStack {
    param(
        [string]$StackName,
        [string]$TemplateFile,
        [string]$Description
    )
    
    Write-Host "`nDeploying $Description..." -ForegroundColor Cyan
    Write-Host "Stack Name: $StackName" -ForegroundColor White
    Write-Host "Template: $TemplateFile" -ForegroundColor White
    
    # Check if stack already exists
    $existingStack = aws cloudformation describe-stacks --stack-name $StackName 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Stack $StackName already exists. Updating..." -ForegroundColor Yellow
        aws cloudformation update-stack --stack-name $StackName --template-body file://$TemplateFile --capabilities CAPABILITY_IAM
    } else {
        Write-Host "Creating new stack $StackName..." -ForegroundColor Yellow
        aws cloudformation create-stack --stack-name $StackName --template-body file://$TemplateFile --capabilities CAPABILITY_IAM
    }
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to deploy $StackName!" -ForegroundColor Red
        return $false
    }
    
    # Wait for stack to complete
    Write-Host "Waiting for stack $StackName to complete..." -ForegroundColor Yellow
    aws cloudformation wait stack-create-complete --stack-name $StackName
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Description deployed successfully!" -ForegroundColor Green
        
        # Get stack outputs
        Write-Host "Stack outputs:" -ForegroundColor Cyan
        aws cloudformation describe-stacks --stack-name $StackName --query 'Stacks[0].Outputs' --output table
        
        return $true
    } else {
        Write-Host "Stack $StackName failed to complete!" -ForegroundColor Red
        return $false
    }
}

# Deploy S3 Buckets Stack
$s3Success = Deploy-CloudFormationStack -StackName "prog8870-s3-buckets-stack" -TemplateFile "cloudformation/s3-buckets.yaml" -Description "S3 Buckets"

if (-not $s3Success) {
    Write-Host "S3 buckets deployment failed. Stopping deployment." -ForegroundColor Red
    exit 1
}

# Deploy EC2 Instance Stack
$ec2Success = Deploy-CloudFormationStack -StackName "prog8870-ec2-instance-stack" -TemplateFile "cloudformation/ec2-instance.yaml" -Description "EC2 Instance"

if (-not $ec2Success) {
    Write-Host "EC2 instance deployment failed. Stopping deployment." -ForegroundColor Red
    exit 1
}

# Deploy RDS Instance Stack
$rdsSuccess = Deploy-CloudFormationStack -StackName "prog8870-rds-instance-stack" -TemplateFile "cloudformation/rds-instance.yaml" -Description "RDS Instance"

if (-not $rdsSuccess) {
    Write-Host "RDS instance deployment failed." -ForegroundColor Red
    exit 1
}

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "All CloudFormation stacks deployed successfully!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# List all stacks
Write-Host "`nAll deployed stacks:" -ForegroundColor Cyan
aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE --query 'StackSummaries[?contains(StackName, `prog8870`)].{StackName:StackName,Status:StackStatus,CreationTime:CreationTime}' --output table

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Take screenshots of the created resources in AWS Console" -ForegroundColor White
Write-Host "2. Get EC2 public IP from CloudFormation outputs" -ForegroundColor White
Write-Host "3. Test the web server by visiting http://<EC2-PUBLIC-IP>" -ForegroundColor White
Write-Host "4. Get RDS endpoint from CloudFormation outputs" -ForegroundColor White
Write-Host "5. Test the RDS database connection" -ForegroundColor White

Write-Host "`nScript completed" -ForegroundColor Green
