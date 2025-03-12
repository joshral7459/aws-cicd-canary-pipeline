#!/bin/bash

# Check if environment parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    echo "Example: $0 dev"
    exit 1
fi

ENVIRONMENT=$1
STACK_NAME="anycompany-pipeline-${ENVIRONMENT}"

# Get ECR repository name
ECR_REPO=$(aws cloudformation describe-stacks \
    --stack-name ${STACK_NAME} \
    --query 'Stacks[0].Outputs[?OutputKey==`ECRRepository`].OutputValue' \
    --output text)

# Delete ECR images
if [ ! -z "$ECR_REPO" ]; then
    echo "Cleaning up ECR repository ${ECR_REPO}..."
    aws ecr batch-delete-image \
        --repository-name ${ECR_REPO} \
        --image-ids "$(aws ecr list-images \
            --repository-name ${ECR_REPO} \
            --query 'imageIds[*]' \
            --output json)"
fi

# Delete CloudFormation stack
echo "Deleting stack ${STACK_NAME}..."
aws cloudformation delete-stack --stack-name ${STACK_NAME}

# Wait for stack deletion to complete
echo "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete --stack-name ${STACK_NAME}

if [ $? -eq 0 ]; then
    echo "Cleanup completed successfully"
else
    echo "Stack deletion failed"
    exit 1
fi
