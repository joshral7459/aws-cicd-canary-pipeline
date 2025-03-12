# Setup Guide

## Prerequisites

1. AWS Account
   - Admin access rights
   - IAM user with programmatic access
   - AWS CLI configured with appropriate credentials

2. GitHub Account
   - Repository admin rights
   - Personal access token with repo and admin:repo_hook permissions

3. Local Development Environment
   - AWS CLI installed and configured
   - Docker installed and running
   - Git installed
   - Python 3.9 or later

## Initial Setup

1. Clone Repository
   ```bash
   git clone https://github.com/your-username/aws-cicd-canary-pipeline.git
   cd aws-cicd-canary-pipeline

2. Configure AWS CLI
   1. aws configure
   2. AWS Access Key ID: [Your Access Key]
   3. AWS Secret Access Key: [Your Secret Key]
   4. Default region name: <region>
   5. Default output format: json


# Deploy dev environment
   "./scripts/deploy.sh dev"

## GitHub Configuration
1.Create GitHub Connection

   1. Go to AWS CodeStar
   2. Click "Create connection"
   3. Select GitHub as provider
   4. Complete OAuth flow
   5. Note the Connection ARN
   6. Update Parameters

## Testing

# Build container locally
docker build -t ${PROJECT_NAME} .
docker run -p 80:80 ${PROJECT_NAME}

3. Pipeline Testing
   1. Make a code change
   2. Commit and push to repository
   3. Monitor pipeline execution
