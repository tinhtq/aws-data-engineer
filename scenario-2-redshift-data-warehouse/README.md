# Scenario 2: Redshift Data Warehouse with ETL Pipeline

## Overview

This scenario demonstrates building a complete data warehouse solution using Amazon Redshift, including data ingestion from multiple sources, ETL processing with AWS Glue, and analytics capabilities. This is a comprehensive data engineering scenario that covers the full data pipeline lifecycle.

## Architecture

```
┌─────────────────┐    ┌──────────────┐    ┌─────────────────┐    ┌──────────────────┐
│   Data Sources  │    │   Amazon S3  │    │   AWS Glue ETL  │    │  Amazon Redshift │
│                 │───▶│  Data Lake   │───▶│   Processing    │───▶│  Data Warehouse  │
│ • CSV Files     │    │  (Raw Zone)  │    │                 │    │                  │
│ • JSON APIs     │    │              │    │                 │    │                  │
│ • RDS Database  │    │              │    │                 │    │                  │
└─────────────────┘    └──────────────┘    └─────────────────┘    └──────────────────┘
                                                    │
                                           ┌─────────────────┐
                                           │  AWS Glue Data  │
                                           │    Catalog      │
                                           └─────────────────┘
```

## Learning Objectives

- **Redshift Architecture**: Understand cluster configuration, node types, and distribution strategies
- **Data Loading**: Learn COPY command, bulk loading, and incremental data loading patterns
- **Schema Design**: Implement star schema, distribution keys, and sort keys for optimal performance
- **ETL Processing**: Use AWS Glue for data transformation and preparation
- **Data Cataloging**: Leverage AWS Glue Data Catalog for metadata management
- **Performance Optimization**: Apply compression, analyze commands, and query optimization
- **Security**: Implement IAM roles, VPC security, and encryption
- **Monitoring**: Set up CloudWatch monitoring and query performance insights

## Scenario Components

### 1. Data Sources
- **Sales Data**: CSV files with transaction records
- **Customer Data**: JSON files from API endpoints
- **Product Catalog**: PostgreSQL RDS database
- **Web Analytics**: Streaming data (simulated with batch files)

### 2. Infrastructure Components
- Amazon Redshift cluster (dc2.large, 2 nodes)
- S3 buckets for data lake (raw, processed, archive)
- AWS Glue ETL jobs and crawlers
- IAM roles and policies
- VPC with proper security groups
- CloudWatch dashboards and alarms

### 3. Data Pipeline
- **Ingestion**: Load raw data into S3 data lake
- **Cataloging**: Use Glue crawlers to discover schema
- **Transformation**: Glue ETL jobs for data cleaning and preparation
- **Loading**: COPY data from S3 to Redshift tables
- **Analytics**: Sample queries and reporting views

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform installed
- Basic SQL knowledge
- Understanding of data warehouse concepts
- Familiarity with star schema design

## Deployment Steps

1. **Infrastructure Setup**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

2. **Data Preparation**
   - Upload sample data to S3
   - Run Glue crawlers to catalog data
   - Execute ETL jobs for data transformation

3. **Redshift Configuration**
   - Create database schemas
   - Define tables with appropriate distribution and sort keys
   - Load data using COPY commands

4. **Analytics Setup**
   - Create views for common queries
   - Set up sample dashboards
   - Configure monitoring and alerts

## Sample Data Model

### Star Schema Design

**Fact Table: sales_fact**
- sale_id (BIGINT, DISTKEY)
- customer_key (INTEGER)
- product_key (INTEGER)
- date_key (INTEGER)
- quantity (INTEGER)
- unit_price (DECIMAL)
- total_amount (DECIMAL)
- discount_amount (DECIMAL)

**Dimension Tables:**
- **dim_customer**: customer demographics and attributes
- **dim_product**: product catalog information
- **dim_date**: date dimension with calendar attributes
- **dim_geography**: location and regional data

## Key Learning Points

### Redshift Best Practices
1. **Distribution Strategy**: Choose appropriate DISTKEY for even data distribution
2. **Sort Keys**: Use SORTKEY for frequently filtered columns
3. **Compression**: Apply column compression to reduce storage and improve performance
4. **Vacuum and Analyze**: Regular maintenance for optimal performance
5. **Workload Management**: Configure WLM queues for different workload types

### ETL Best Practices
1. **Incremental Loading**: Implement change data capture patterns
2. **Data Quality**: Add validation and cleansing steps
3. **Error Handling**: Implement retry logic and error notifications
4. **Monitoring**: Track job performance and data lineage
5. **Cost Optimization**: Use appropriate Glue DPU settings

## Performance Optimization Techniques

1. **Query Optimization**
   - Use EXPLAIN to analyze query plans
   - Implement proper JOIN strategies
   - Leverage materialized views for complex aggregations

2. **Storage Optimization**
   - Choose appropriate data types
   - Implement table partitioning strategies
   - Use columnar compression effectively

3. **Cluster Management**
   - Monitor cluster utilization
   - Implement auto-scaling strategies
   - Optimize node types for workload

## Monitoring and Troubleshooting

- CloudWatch metrics for cluster performance
- Query performance insights
- System tables for monitoring queries
- Automated alerts for performance issues
- Cost monitoring and optimization

## Sample Queries

The scenario includes sample analytical queries demonstrating:
- Sales performance analysis
- Customer segmentation
- Product performance metrics
- Time-series analysis
- Geographic analysis

## Cost Considerations

- Redshift cluster costs (approximately $0.25/hour for dc2.large)
- S3 storage costs for data lake
- Glue ETL job costs
- Data transfer costs
- Always pause/delete resources after learning

## Cleanup

```bash
terraform destroy
```

This will remove all created resources to avoid ongoing charges.

## Next Steps

After completing this scenario, you'll be ready to:
- Implement real-time data streaming with Kinesis
- Add machine learning capabilities with SageMaker
- Implement advanced analytics with Athena and QuickSight
- Design multi-region data replication strategies

## Certification Exam Topics Covered

- Data warehouse design and implementation
- ETL pipeline development and optimization
- Data modeling and schema design
- Performance tuning and optimization
- Security and access control
- Monitoring and troubleshooting
- Cost optimization strategies
