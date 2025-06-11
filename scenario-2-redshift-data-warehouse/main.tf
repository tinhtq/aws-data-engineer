# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-vpc"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-igw"
  })
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
    Type = "Public"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
    Type = "Private"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# S3 Buckets for Data Lake
resource "aws_s3_bucket" "data_lake_raw" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${var.project_name}-raw-${random_string.bucket_suffix.result}"
  force_destroy = true

  tags = merge(var.tags, {
    Name = "Data Lake Raw Zone"
    Zone = "Raw"
  })
}

resource "aws_s3_bucket" "data_lake_processed" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${var.project_name}-processed-${random_string.bucket_suffix.result}"
  force_destroy = true

  tags = merge(var.tags, {
    Name = "Data Lake Processed Zone"
    Zone = "Processed"
  })
}

resource "aws_s3_bucket" "data_lake_archive" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${var.project_name}-archive-${random_string.bucket_suffix.result}"
  force_destroy = true

  tags = merge(var.tags, {
    Name = "Data Lake Archive Zone"
    Zone = "Archive"
  })
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "data_lake_raw" {
  bucket = aws_s3_bucket.data_lake_raw.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "data_lake_processed" {
  bucket = aws_s3_bucket.data_lake_processed.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake_raw" {
  bucket = aws_s3_bucket.data_lake_raw.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake_processed" {
  bucket = aws_s3_bucket.data_lake_processed.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake_archive" {
  bucket = aws_s3_bucket.data_lake_archive.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# IAM Role for Redshift
resource "aws_iam_role" "redshift_role" {
  name = "${var.project_name}-redshift-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "redshift_s3_policy" {
  name = "${var.project_name}-redshift-s3-policy"
  role = aws_iam_role.redshift_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.data_lake_raw.arn,
          "${aws_s3_bucket.data_lake_raw.arn}/*",
          aws_s3_bucket.data_lake_processed.arn,
          "${aws_s3_bucket.data_lake_processed.arn}/*"
        ]
      }
    ]
  })
}

# IAM Role for Glue
resource "aws_iam_role" "glue_role" {
  name = "${var.project_name}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_s3_policy" {
  name = "${var.project_name}-glue-s3-policy"
  role = aws_iam_role.glue_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.data_lake_raw.arn,
          "${aws_s3_bucket.data_lake_raw.arn}/*",
          aws_s3_bucket.data_lake_processed.arn,
          "${aws_s3_bucket.data_lake_processed.arn}/*"
        ]
      }
    ]
  })
}

# Security Group for Redshift
resource "aws_security_group" "redshift" {
  name_prefix = "${var.project_name}-redshift-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Redshift access from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-redshift-sg"
  })
}

# Redshift Subnet Group
resource "aws_redshift_subnet_group" "main" {
  name       = "${var.project_name}-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = merge(var.tags, {
    Name = "${var.project_name}-redshift-subnet-group"
  })
}

# Redshift Cluster
resource "aws_redshift_cluster" "main" {
  cluster_identifier        = var.redshift_cluster_identifier
  database_name            = var.redshift_database_name
  master_username          = var.redshift_master_username
  master_password          = var.redshift_master_password
  node_type                = var.redshift_node_type
  number_of_nodes          = var.redshift_number_of_nodes
  
  db_subnet_group_name     = aws_redshift_subnet_group.main.name
  vpc_security_group_ids   = [aws_security_group.redshift.id]
  iam_roles                = [aws_iam_role.redshift_role.arn]
  
  publicly_accessible      = false
  encrypted                = true
  skip_final_snapshot      = true
  
  # Enable logging
  logging {
    enable        = true
    bucket_name   = aws_s3_bucket.data_lake_archive.bucket
    s3_key_prefix = "redshift-logs/"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-redshift-cluster"
  })
}

# Glue Database
resource "aws_glue_catalog_database" "main" {
  name        = "${replace(var.project_name, "-", "_")}_catalog"
  description = "Glue catalog database for ${var.project_name}"
}

# Glue Crawler for Raw Data
resource "aws_glue_crawler" "raw_data" {
  database_name = aws_glue_catalog_database.main.name
  name          = "${var.project_name}-raw-data-crawler"
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.data_lake_raw.bucket}/"
  }

  tags = var.tags
}

# CloudWatch Log Group for Glue Jobs
resource "aws_cloudwatch_log_group" "glue_jobs" {
  name              = "/aws-glue/jobs/${var.project_name}"
  retention_in_days = 7

  tags = var.tags
}
