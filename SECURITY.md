# Security Guidelines

## 🔒 Credential Management

### ❌ Never Commit These Files:
- `terraform.tfvars` (contains actual passwords)
- `account-config.tf` (contains AWS account ID)
- `.env` files
- AWS credential files
- Private keys or certificates
- Any file with actual passwords, tokens, API keys, or account IDs

### ✅ Safe to Commit:
- `terraform.tfvars.example` (template with placeholder values)
- `account-config.tf.example` (template for account configuration)
- Terraform configuration files (`.tf`)
- Documentation files

## 🛡️ Security Scanning

This repository includes automated security scanning that runs on every push:

### Tools Used:
1. **TruffleHog** - Detects secrets in git history
2. **detect-secrets** - Baseline secret detection
3. **GitLeaks** - Git repository secret scanner
4. **Checkov** - Terraform security scanner
5. **TFSec** - Terraform static analysis

### What Gets Checked:
- AWS access keys and secret keys
- Database connection strings with credentials
- Private keys and certificates
- Hardcoded passwords in code
- Terraform security misconfigurations
- Common credential patterns

## 🚨 If Secrets Are Detected:

1. **Don't panic** - Remove the secret from your code
2. **Rotate the credential** - Generate a new password/key
3. **Clean git history** if the secret was committed:
   ```bash
   # For recent commits
   git reset --soft HEAD~1
   git reset HEAD .
   
   # For older commits, use git filter-branch or BFG Repo-Cleaner
   ```

## 📋 Best Practices:

### For Terraform:
- Use `terraform.tfvars` for sensitive values (gitignored)
- Mark variables as `sensitive = true`
- Use AWS Secrets Manager or Parameter Store for production
- Never hardcode credentials in `.tf` files

### For Development:
- Use environment variables for local development
- Use AWS profiles instead of hardcoded keys
- Enable MFA on your AWS account
- Regularly rotate credentials

### Example Secure Terraform Variable:
```hcl
variable "mysql_password" {
  description = "MySQL database password"
  type        = string
  sensitive   = true  # This prevents the value from being displayed in logs
}
```

## 🔧 Local Security Scanning:

Run these commands locally before pushing:

```bash
# Install and run GitLeaks
brew install gitleaks
gitleaks detect --source . --verbose

# Install and run detect-secrets
pip install detect-secrets
detect-secrets scan --all-files

# Run Terraform security scan
docker run --rm -v $(pwd):/tf bridgecrew/checkov -d /tf
```

## 📞 Security Contact:

If you discover a security vulnerability, please:
1. Do not create a public GitHub issue
2. Contact the repository maintainer directly
3. Provide details about the vulnerability
4. Allow time for the issue to be addressed before public disclosure
