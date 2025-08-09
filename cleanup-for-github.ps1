# Simple cleanup script for GitHub
# This removes files that should NOT go to GitHub

Write-Host "🧹 Cleaning up files for GitHub..." -ForegroundColor Yellow

# Remove Terraform state files (contain sensitive data)
if (Test-Path "terraform\terraform.tfstate") {
    Remove-Item "terraform\terraform.tfstate" -Force
    Write-Host "✅ Deleted: terraform.tfstate" -ForegroundColor Green
}

if (Test-Path "terraform\terraform.tfstate.backup") {
    Remove-Item "terraform\terraform.tfstate.backup" -Force
    Write-Host "✅ Deleted: terraform.tfstate.backup" -ForegroundColor Green
}

# Remove plan file
if (Test-Path "terraform\tfplan") {
    Remove-Item "terraform\tfplan" -Force
    Write-Host "✅ Deleted: tfplan" -ForegroundColor Green
}

# Remove SSH keys
if (Test-Path "terraform\ssh") {
    Remove-Item "terraform\ssh" -Recurse -Force
    Write-Host "✅ Deleted: SSH keys folder" -ForegroundColor Green
}

# Remove terraform.tfvars (contains password)
if (Test-Path "terraform\terraform.tfvars") {
    Remove-Item "terraform\terraform.tfvars" -Force
    Write-Host "✅ Deleted: terraform.tfvars (contains password)" -ForegroundColor Green
}

# Remove extra documentation files (optional)
$extraFiles = @("PRESENTATION_TEMPLATE.md", "PROJECT_CHECKLIST.md", "PROJECT_SUMMARY.md")
foreach ($file in $extraFiles) {
    if (Test-Path $file) {
        Remove-Item $file -Force
        Write-Host "✅ Deleted: $file" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "🎉 Cleanup complete! Your project is ready for GitHub." -ForegroundColor Cyan
Write-Host "Now you can safely push to GitHub without exposing secrets." -ForegroundColor Cyan
