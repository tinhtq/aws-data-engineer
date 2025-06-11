output "redshift_cluster_endpoint" {
  description = "Redshift cluster endpoint"
  value       = aws_redshift_cluster.main.endpoint
}

output "redshift_cluster_id" {
  description = "Redshift cluster identifier"
  value       = aws_redshift_cluster.main.cluster_identifier
}

output "redshift_database_name" {
  description = "Redshift database name"
  value       = aws_redshift_cluster.main.database_name
}

output "redshift_master_username" {
  description = "Redshift master username"
  value       = aws_redshift_cluster.main.master_username
  sensitive   = true
}

output "s3_bucket_raw" {
  description = "S3 bucket for raw data"
  value       = aws_s3_bucket.data_lake_raw.bucket
}

output "s3_bucket_processed" {
  description = "S3 bucket for processed data"
  value       = aws_s3_bucket.data_lake_processed.bucket
}

output "s3_bucket_archive" {
  description = "S3 bucket for archived data"
  value       = aws_s3_bucket.data_lake_archive.bucket
}

output "glue_database_name" {
  description = "Glue catalog database name"
  value       = aws_glue_catalog_database.main.name
}

output "glue_crawler_name" {
  description = "Glue crawler name for raw data"
  value       = aws_glue_crawler.raw_data.name
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "redshift_iam_role_arn" {
  description = "IAM role ARN for Redshift"
  value       = aws_iam_role.redshift_role.arn
}

output "glue_iam_role_arn" {
  description = "IAM role ARN for Glue"
  value       = aws_iam_role.glue_role.arn
}

output "connection_info" {
  description = "Connection information for accessing Redshift"
  value = {
    endpoint = aws_redshift_cluster.main.endpoint
    port     = aws_redshift_cluster.main.port
    database = aws_redshift_cluster.main.database_name
    username = aws_redshift_cluster.main.master_username
  }
  sensitive = true
}
