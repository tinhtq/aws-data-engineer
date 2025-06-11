# Scenario 1: MySQL to Amazon Redshift Migration

## Overview
This scenario demonstrates migrating transactional data from a MySQL database to Amazon Redshift for analytics workloads. This is a common pattern in data engineering where OLTP data needs to be moved to an OLAP system.

## Architecture
```
MySQL RDS → DMS Replication Instance → Amazon Redshift
```

## Learning Objectives
- Set up DMS replication instance and subnet groups
- Configure source and target endpoints
- Create migration tasks with full load + CDC
- Monitor migration progress and troubleshoot issues
- Understand data type mappings between MySQL and Redshift

## Prerequisites
1. MySQL RDS instance (source)
2. Amazon Redshift cluster (target)
3. Appropriate IAM permissions for DMS
4. Network connectivity between source, DMS, and target

## Step-by-Step Implementation

### Step 1: Deploy Infrastructure
```bash
# Verify AWS account
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
if [ "$ACCOUNT_ID" != "276084501312" ]; then
  echo "ERROR: Wrong AWS account. Expected 276084501312, got $ACCOUNT_ID"
  exit 1
fi

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply
```

### Step 2: Test Endpoint Connections
```bash
# Test source endpoint
aws dms test-connection \
  --replication-instance-arn <replication-instance-arn> \
  --endpoint-arn <source-endpoint-arn>

# Test target endpoint
aws dms test-connection \
  --replication-instance-arn <replication-instance-arn> \
  --endpoint-arn <target-endpoint-arn>
```

### Step 3: Start Migration Task
```bash
# Start the migration task
aws dms start-replication-task \
  --replication-task-arn <task-arn> \
  --start-replication-task-type start-replication
```

### Step 4: Monitor Migration
```bash
# Check task status
aws dms describe-replication-tasks \
  --filters Name=replication-task-id,Values=mysql-to-redshift-task

# Monitor table statistics
aws dms describe-table-statistics \
  --replication-task-arn <task-arn>
```

## Key Configuration Files

### table-mappings.json
Defines which tables to migrate and any transformation rules:
- Selection rules: Which schemas/tables to include
- Transformation rules: How to modify data during migration
- Filtering rules: Conditions for data selection

### Task Settings (Optional)
Can be added to control:
- Logging level and CloudWatch integration
- Error handling behavior
- Performance tuning parameters
- Target table preparation mode

## Common Issues and Solutions

### 1. Connection Issues
- Check security groups allow traffic on database ports
- Verify network ACLs and routing
- Ensure DMS has proper IAM permissions

### 2. Data Type Mapping Issues
- Review MySQL to Redshift data type mappings
- Handle unsupported data types with transformation rules
- Consider VARCHAR length limitations in Redshift

### 3. Performance Issues
- Adjust replication instance size
- Optimize source database for CDC
- Configure parallel load settings

## Monitoring and Troubleshooting

### CloudWatch Metrics to Monitor
- `CDCLatencySource`: Lag between source and DMS
- `CDCLatencyTarget`: Lag between DMS and target
- `FreeableMemory`: Available memory on replication instance
- `CPUUtilization`: CPU usage of replication instance

### Log Analysis
```bash
# View DMS logs in CloudWatch
aws logs describe-log-groups --log-group-name-prefix dms-tasks

# Get specific log events
aws logs get-log-events \
  --log-group-name dms-tasks-mysql-to-redshift-task \
  --log-stream-name <log-stream-name>
```

## Data Validation

### Row Count Validation
```sql
-- Source (MySQL)
SELECT COUNT(*) FROM source_table;

-- Target (Redshift)
SELECT COUNT(*) FROM target_table;
```

### Data Sampling
```sql
-- Compare sample data
SELECT * FROM source_table LIMIT 10;
SELECT * FROM target_table LIMIT 10;
```

## Cleanup
```bash
# Stop replication task
aws dms stop-replication-task --replication-task-arn <task-arn>

# Destroy infrastructure
terraform destroy
```

## Cost Optimization Tips
- Use appropriate replication instance size
- Stop tasks when not needed
- Consider using spot instances for non-production
- Monitor data transfer costs

## Next Steps
- Explore transformation rules for data modification
- Implement error handling and retry logic
- Set up automated monitoring and alerting
- Practice with different migration types (full-load only, CDC only)
