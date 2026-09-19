variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "wordpress_db_password" {
  description = "Password for the WordPress database user"
  type        = string
  sensitive   = true
}