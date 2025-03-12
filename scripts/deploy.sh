#!/bin/bash

# Check if environment parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    echo "Example: $0 dev"
    exit 1
fi

ENVIRONMENT=$1
STACK_NAME="anycompany-pipeline-${ENVIRONMENT}"
TEMPLATE_FILE="templates/main.yaml"
PARAMS_FILE="templates/parameters/${ENVIRONMENT}.json"

# Validate template
echo "Validating CloudFormation template..."
aws cloudformation validate-template \
    --template-body file://${TEMPLATE_FILE}

if [ $? -ne 0 ]; then
    echo "Template validation failed"
    exit 1
fi

# Deploy stack
echo "Deploying stack ${STACK_NAME}..."
aws cloudformation deploy \
    --template-file ${TEMPLATE_FILE} \
    --stack-name ${STACK_NAME} \
    --parameter-overrides file://${PARAMS_FILE} \
    --capabilities CAPABILITY_NAMED_IAM \
    --tags Environment=${ENVIRONMENT}

if [ $? -ne 0 ]; then
    echo "Stack deployment failed"
    exit 1
fi

echo "Deployment completed successfully"
