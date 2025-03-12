# AWS CI/CD Pipeline with Canary Deployments

This repository contains CloudFormation templates and configuration files for implementing a CI/CD pipeline with canary deployments in AWS.

## Architecture Overview

This solution implements:
- CodePipeline for CI/CD orchestration
- ECS Fargate for container deployment
- Application Load Balancer for traffic management
- Lambda functions for traffic shifting
- CloudWatch for monitoring and logging

## Prerequisites

- AWS Account
- GitHub Account
- AWS CLI configured
- Docker installed locally
- GitHub repository access

## Quick Start

1. Clone this repository
2. Deploy the CloudFormation template
3. Configure GitHub connection
4. Push your application code
5. Monitor the pipeline

## Repository Structure

- `/templates` - CloudFormation templates
- `/config` - Configuration files
- `/docs` - Documentation
- `/scripts` - Utility scripts

## Deployment Guide

See [setup.md](docs/setup.md) for detailed deployment instructions.

## Contributing

Pull requests are welcome. For major changes, please open an issue first.

## License

[MIT](LICENSE)
