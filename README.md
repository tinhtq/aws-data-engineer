# AWS Data Engineering Learning Repository

This repository contains comprehensive hands-on scenarios and practical exercises for mastering AWS Data Engineering concepts, with a focus on preparing for the AWS Certified Data Engineer - Associate certification.

## 🎯 Learning Objectives

**Core Data Engineering Skills:**
- Design and implement scalable data pipelines on AWS
- Master data ingestion, transformation, and storage patterns
- Build real-time and batch processing solutions
- Implement data governance and security best practices
- Optimize performance and cost for data workloads
- Monitor and troubleshoot data engineering solutions

**AWS Data Services Covered:**
- **Data Migration**: AWS DMS, AWS SCT
- **Data Storage**: Amazon S3, Amazon Redshift, Amazon RDS, DynamoDB
- **Data Processing**: AWS Glue, Amazon EMR, AWS Lambda
- **Data Streaming**: Amazon Kinesis, Amazon MSK
- **Data Analytics**: Amazon Athena, Amazon QuickSight
- **Orchestration**: AWS Step Functions, Amazon MWAA

## 📚 Learning Scenarios Overview

### Scenario 1: MySQL to Amazon Redshift
**Use Case**: Migrate transactional data from MySQL to Redshift for analytics
- **Source**: MySQL RDS instance
- **Target**: Amazon Redshift cluster
- **Migration Type**: Full load + CDC
- **Learning Focus**: Data warehouse migration patterns

### Scenario 2: PostgreSQL to Amazon S3
**Use Case**: Archive PostgreSQL data to S3 for long-term storage and analytics
- **Source**: PostgreSQL RDS instance
- **Target**: Amazon S3 (Parquet format)
- **Migration Type**: Full load
- **Learning Focus**: Data lake ingestion patterns

### Scenario 3: Oracle to Amazon Aurora
**Use Case**: Modernize legacy Oracle database to Aurora PostgreSQL
- **Source**: Oracle RDS instance
- **Target**: Aurora PostgreSQL cluster
- **Migration Type**: Full load + CDC
- **Learning Focus**: Database modernization and schema conversion

### Scenario 4: MongoDB to DynamoDB
**Use Case**: Migrate NoSQL data from MongoDB to DynamoDB
- **Source**: MongoDB (DocumentDB)
- **Target**: Amazon DynamoDB
- **Migration Type**: Full load
- **Learning Focus**: NoSQL to NoSQL migration patterns

### Scenario 5: Continuous Replication Setup
**Use Case**: Set up ongoing replication for hybrid cloud scenarios
- **Source**: On-premises MySQL (simulated with EC2)
- **Target**: Multiple targets (RDS, S3, Redshift)
- **Migration Type**: CDC only
- **Learning Focus**: Real-time data replication and multi-target scenarios

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform installed
- Basic understanding of database concepts
- Familiarity with AWS networking (VPC, subnets, security groups)

## DMS Key Concepts to Learn

1. **Replication Instance**: The compute resource that runs the migration tasks
2. **Endpoints**: Source and target database connections
3. **Migration Tasks**: Define what data to migrate and how
4. **Task Settings**: Control migration behavior and performance
5. **Table Mappings**: Define which tables/schemas to migrate
6. **Transformation Rules**: Modify data during migration

## Common DMS Use Cases

- **Database Migration**: Move databases to AWS
- **Database Replication**: Keep databases in sync
- **Data Integration**: Combine data from multiple sources
- **Analytics Preparation**: Move transactional data to analytical systems
- **Disaster Recovery**: Maintain standby databases

## Best Practices to Implement

- Use appropriate instance classes for replication instances
- Configure proper security groups and network access
- Monitor replication lag and performance metrics
- Handle large object (LOB) data appropriately
- Implement proper error handling and logging
- Test migration tasks thoroughly before production

## Getting Started

1. Choose a scenario directory
2. Review the README in that directory
3. Deploy the infrastructure using Terraform
4. Follow the step-by-step migration guide
5. Monitor the migration process
6. Clean up resources when done

## Cost Considerations

- DMS replication instances incur hourly charges
- Data transfer costs may apply
- Target database costs (RDS, Redshift, etc.)
- Always clean up resources after learning exercises

## Certification Exam Topics Covered

- Database migration planning and execution
- DMS architecture and components
- Migration task configuration
- Monitoring and troubleshooting
- Security and networking considerations
- Performance optimization techniques
