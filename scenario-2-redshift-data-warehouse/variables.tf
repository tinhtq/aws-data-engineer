variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "redshift-data-warehouse"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "learning"
}

variable "redshift_cluster_identifier" {
  description = "Identifier for the Redshift cluster"
  type        = string
  default     = "data-warehouse-cluster"
}

variable "redshift_database_name" {
  description = "Name of the Redshift database"
  type        = string
  default     = "datawarehouse"
}

variable "redshift_master_username" {
  description = "Master username for Redshift cluster"
  type        = string
  default     = "admin"
}

variable "redshift_master_password" {
  description = "Master password for Redshift cluster"
  type        = string
  sensitive   = true
  default     = "TempPassword123!"
}

variable "redshift_node_type" {
  description = "Node type for Redshift cluster"
  type        = string
  default     = "dc2.large"
}

variable "redshift_number_of_nodes" {
  description = "Number of nodes in Redshift cluster"
  type        = number
  default     = 2
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project     = "AWS Data Engineering Learning"
    Scenario    = "Redshift Data Warehouse"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}
