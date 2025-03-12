# Setup Guide

## Prerequisites

1. AWS Account
2. GitHub Account
3. AWS CLI installed and configured
4. Docker installed locally

## Initial Setup

1. Clone Repository
   ```bash
   git clone https://github.com/your-username/aws-cicd-canary-pipeline.git
   cd aws-cicd-canary-pipeline
   
2. aws configure

3. ./scripts/deploy.sh dev

4. GitHub Configuration
  1. Create GitHub Connection in AWS CodeStar
  2. Configure webhook
  3. Update parameters file with repository details

5. Pipeline Configuration
  1. Update buildspec.yml if needed
  2. Configure environment variables
  3. Set up notifications
   
6. Testing
  1. Make a code change
  2. Push to repository
  3. Monitor pipeline execution
  4. Verify canary deployment


7. docs/configuration.md:
   
# Configuration Guide

## Environment Variables

### Required Variables
- AWS_ACCOUNT_ID
- AWS_REGION
- ENVIRONMENT

### Optional Variables
- CONTAINER_PORT
- HEALTH_CHECK_PATH
- LOG_LEVEL

## Pipeline Configuration

### Source Stage
- Repository: GitHub
- Branch: main
- Events: push

### Build Stage
- Environment: AWS Linux 2
- Type: Docker
- Compute: 3GB memory

### Deploy Stage
- Type: ECS
- Cluster: anycompany-cluster
- Service: auto-created

## Monitoring

### CloudWatch Alarms
- HTTP 5xx errors
- Response latency
- CPU utilization
- Memory utilization

### Logs
- Application logs
- Access logs
- Build logs
