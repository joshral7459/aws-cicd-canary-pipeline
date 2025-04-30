# Canary Deployment Workshop Foundation

This repository contains the foundation CloudFormation templates for a workshop on implementing CI/CD pipelines with canary deployments using AWS CodePipeline and CodeDeploy.

## Architecture

The foundation template sets up the following AWS resources:

- **VPC** with public subnets
- **IAM** roles and policies
- **Security Groups** for ALB and ECS
- **Application Load Balancer** with target groups
- **ECR Repository** for container images
- **ECS Cluster** with production (0 tasks) and canary (0 tasks) services

## Prerequisites

- AWS CLI installed and configured
- Docker installed
- Git installed

## Deployment Instructions

### 1. Clone the GitHub Repository

First, clone the central GitHub repository containing all the workshop templates and files:

```bash
# Clone the repository
git clone https://github.com/joshral7459/aws-cicd-canary-pipeline.git

# Navigate to the repository directory
cd aws-cicd-canary-pipeline

# Verify all required files are present
ls -la Templates/
```

The repository contains all the necessary CloudFormation templates and application files organized in the following structure:
- `Templates/` - Contains all CloudFormation templates
- `APP/` - Contains the sample application files
- `CICD/` - Contains CI/CD configuration files

### 2. Deploy the CloudFormation Stack

Deploy the root stack using the AWS CLI directly from your local copy of the repository:

```bash
aws cloudformation create-stack \
  --stack-name canary-workshop \
  --template-body file://Templates/root-stack.yaml \
  --parameters ParameterKey=ProjectName,ParameterValue=canary-workshop \
  --capabilities CAPABILITY_NAMED_IAM
```

Or deploy using the AWS Management Console:

1. Go to CloudFormation in the AWS Management Console
2. Click "Create stack" > "With new resources (standard)"
3. Select "Upload a template file" and upload the root-stack.yaml file from your local repository
4. Follow the prompts to complete the deployment

### 3. Workshop Flow: Manual Deployment First

The CloudFormation stack deploys with both ECS services set to 0 tasks. This is intentional to demonstrate the manual deployment process before introducing CI/CD automation.

#### Step 1: Manual Image Deployment

Participants will first experience the manual deployment process using the files provided in the repository:

```bash
# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=<your-region>  # e.g., us-east-1
PROJECT_NAME=canary-workshop

# Navigate to the APP directory which contains the Dockerfile and HTML files
cd APP

# Review the Dockerfile and HTML content
cat html/Dockerfile
cat html/index.html

# Build the Docker image using the provided files
docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME-repository:latest -f html/Dockerfile html/

# Log in to Amazon ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Push the image to ECR
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME-repository:latest

# Update the ECS service to run 2 tasks
aws ecs update-service --cluster $PROJECT_NAME-cluster \
  --service $PROJECT_NAME-production \
  --desired-count 2 \
  --region $AWS_REGION
```

This demonstrates the traditional deployment approach:
1. Manually build Docker images
2. Manually authenticate with ECR
3. Manually push images to the repository
4. Manually update ECS services
5. Wait for deployments to complete
6. Verify the application is working

#### Step 2: CI/CD Pipeline Setup

After experiencing the manual process, participants will set up the CI/CD pipeline:

1. Create a CodeBuild project using the provided `buildspec.yml`

2. Set up CodeDeploy using the provided `appspec.yaml`
   - Manually update the placeholders in appspec.yaml with actual values:
     ```yaml
     # Replace these placeholders with actual values from CloudFormation outputs
     <HTTP_LISTENER_ARN>           # From HTTPListenerArn output
     <PRODUCTION_TARGET_GROUP_ARN> # From ProductionTargetGroupArn output
     <CANARY_TARGET_GROUP_ARN>     # From CanaryTargetGroupArn output
     <ECS_SECURITY_GROUP>          # From ECSSecurityGroup output
     <PUBLIC_SUBNET_1>             # From PublicSubnet1 output
     <PUBLIC_SUBNET_2>             # From PublicSubnet2 output
     ```
   - You can get these values using the AWS CLI:
     ```bash
     aws cloudformation describe-stacks --stack-name canary-workshop --query "Stacks[0].Outputs" --output table
     ```

3. Create a CodePipeline with Source, Build, and Deploy stages

4. Configure canary deployments with traffic shifting

#### Step 3: Automated Deployment

For the second deployment, participants will:

1. Make changes to the HTML files (e.g., create a v2 version)
2. Commit and push the changes to the source repository
3. Watch the pipeline automatically build and deploy the changes
4. Observe the canary deployment process with traffic shifting

This contrast between manual and automated deployments effectively demonstrates the benefits of CI/CD pipelines.

## Blue/Green Deployment Option

The foundation template is configured to support blue/green deployments through AWS CodeDeploy. The canary service (initially set to 0 tasks) can be used as the green environment during deployments.

## Notes

- The template does not include domain configuration as specified in the requirements
- IAM roles and policies are configured with the necessary permissions for ECS tasks and future CodeDeploy integration
- TaskExecutionRole and TaskRole are properly configured in the IAM stack and directly imported by the ECS task definition
- ECS services are initially set to 0 tasks to prevent deployment failures when no container image exists yet
- The load balancer is configured with a default listener rule for production traffic and a path-based rule for canary traffic (/canary*)
