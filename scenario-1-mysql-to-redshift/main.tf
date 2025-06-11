# Data source to get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to get all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Groups
resource "aws_security_group" "dms" {
  name_prefix = "dms-replication-instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dms-replication-instance-sg"
  }
}

# DMS Replication Subnet Group
resource "aws_dms_replication_subnet_group" "example" {
  replication_subnet_group_description = "DMS replication subnet group"
  replication_subnet_group_id         = "dms-subnet-group"

  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "dms-replication-subnet-group"
  }
}

# DMS Replication Instance
resource "aws_dms_replication_instance" "example" {
  allocated_storage               = 50
  apply_immediately              = true
  auto_minor_version_upgrade     = true
  multi_az                       = false
  publicly_accessible            = false
  replication_instance_class     = "dms.t3.medium"
  replication_instance_id        = "dms-mysql-to-redshift"
  replication_subnet_group_id    = aws_dms_replication_subnet_group.example.id
  vpc_security_group_ids         = [aws_security_group.dms.id]

  tags = {
    Name = "dms-mysql-to-redshift"
  }
}

# Source MySQL Endpoint
resource "aws_dms_endpoint" "source" {
  database_name = "source_db"
  endpoint_id   = "source-mysql"
  endpoint_type = "source"
  engine_name   = "mysql"
  username      = var.mysql_username
  password      = var.mysql_password
  port          = 3306
  server_name   = var.mysql_host

  tags = {
    Name = "source-mysql"
  }
}

# Target Redshift Endpoint
resource "aws_dms_endpoint" "target" {
  database_name = "target_db"
  endpoint_id   = "target-redshift"
  endpoint_type = "target"
  engine_name   = "redshift"
  username      = var.redshift_username
  password      = var.redshift_password
  port          = 5439
  server_name   = var.redshift_host

  tags = {
    Name = "target-redshift"
  }
}

# DMS Migration Task
resource "aws_dms_replication_task" "example" {
  migration_type           = "full-load-and-cdc"
  replication_instance_arn = aws_dms_replication_instance.example.replication_instance_arn
  replication_task_id      = "mysql-to-redshift-task"
  source_endpoint_arn      = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn      = aws_dms_endpoint.target.endpoint_arn
  table_mappings          = file("${path.module}/table-mappings.json")

  tags = {
    Name = "mysql-to-redshift-task"
  }
}
