# Database Configuration
variable "mysql_username" {
  description = "MySQL database username"
  type        = string
  default     = "admin"
}

variable "mysql_password" {
  description = "MySQL database password"
  type        = string
  sensitive   = true
}

variable "mysql_host" {
  description = "MySQL database host"
  type        = string
}

variable "redshift_username" {
  description = "Redshift database username"
  type        = string
  default     = "admin"
}

variable "redshift_password" {
  description = "Redshift database password"
  type        = string
  sensitive   = true
}

variable "redshift_host" {
  description = "Redshift cluster endpoint"
  type        = string
}
