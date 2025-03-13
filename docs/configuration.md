# Configuration Guide

## Environment Variables

### Required Variables
- AWS_ACCOUNT_ID
- AWS_REGION
- ENVIRONMENT
- PROJECT_NAME
- GITHUB_TOKEN

### Optional Variables
- CONTAINER_PORT (default: 80)
- HEALTH_CHECK_PATH (default: /healthcheck.php)
- LOG_LEVEL (default: info)

## Application Configuration

### Container Environment Variables
- APP_ENV: [dev/prod]
- APP_DEBUG: [true/false]
- APP_LOG_LEVEL: [debug/info/error]

### Health Check Settings
- Path: /healthcheck.php
- Interval: 30 seconds
- Timeout: 5 seconds
- Healthy threshold: 3
- Unhealthy threshold: 2

## Monitoring Configuration

### CloudWatch Logs
- Application logs: /ecs/${PROJECT_NAME}
- Access logs: /aws/applicationlb/${PROJECT_NAME}
- Build logs: /aws/codebuild/${PROJECT_NAME}

### Metrics to Monitor
- HTTP response codes (2xx, 4xx, 5xx)
- Response times
- Request count
- CPU utilization
- Memory utilization

## Notification Settings

### Email Notifications
- Pipeline state changes
- Deployment approvals
- Error alerts

### Slack Notifications (Optional)
- Channel: #deployments
- Events to notify:
  - Pipeline start
  - Stage completion
  - Deployment approval needed
  - Pipeline completion
  - Errors

## Pipeline Triggers

### Automatic Triggers
- Push to main branch
- Pull request creation
- Tag creation

### Manual Triggers
- Manual approval actions
- Force rebuild options
