variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "region" {
  description = "The aws region"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Name to be used on all the resources as identifier"
  type = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Environment" = "assignment"
  }
}

variable "public_subnet_numbers" {
  default = {
    "ap-south-1a" = 1
    "ap-south-1b" = 2
    "ap-south-1c" = 3
  }
}

variable "private_subnet_numbers" {
  default = {
    "ap-south-1a" = 4
    "ap-south-1b" = 5
    "ap-south-1c" = 6
  }
}

variable "k8s_namespace" {
  description = "Kubernetes namespace name"
  type        = string
  default     = "default"
}