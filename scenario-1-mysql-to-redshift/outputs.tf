output "replication_instance_arn" {
  description = "ARN of the DMS replication instance"
  value       = aws_dms_replication_instance.example.replication_instance_arn
}

output "replication_instance_id" {
  description = "ID of the DMS replication instance"
  value       = aws_dms_replication_instance.example.replication_instance_id
}

output "source_endpoint_arn" {
  description = "ARN of the source MySQL endpoint"
  value       = aws_dms_endpoint.source.endpoint_arn
}

output "target_endpoint_arn" {
  description = "ARN of the target Redshift endpoint"
  value       = aws_dms_endpoint.target.endpoint_arn
}

output "migration_task_arn" {
  description = "ARN of the DMS migration task"
  value       = aws_dms_replication_task.example.replication_task_arn
}

output "vpc_id" {
  description = "ID of the default VPC used"
  value       = data.aws_vpc.default.id
}

output "subnet_ids" {
  description = "IDs of the subnets used"
  value       = data.aws_subnets.default.ids
}

output "dms_security_group_id" {
  description = "ID of the DMS security group"
  value       = aws_security_group.dms.id
}
