# Single variable containing 2 string values
variable "app_details" {
  type = list(string)
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "aws_region_az" {
  description = "AWS region AZ"
  default     = "us-west-2b"
}

variable "ami_id" {
  description = "ID of the AMI to provision. Default is Ubuntu 14.04 Base Image"
  default     = "ami-0854e54abaeae283b"
}

variable "instance_type" {
  description = "type of EC2 instance to provision."
  default     = "t3.micro"
}

variable "name" {
  description = "name to pass to Name tag"
  default     = "akshay1-infra-provisioner"
}

variable "name1" {
  description = "name to pass to Name1 tag"
  default     = "akshay2-infra-provisioner"
}

variable "email" {
  description = "email"
  default     = "akshay@rafay.co"
}

variable "tag_project" {
  type        = list(string)
  description = "Project tag for EC2 instances"
  default     = ["customer-takeda"]
}

variable "tag_team" {
  type        = list(string)
  description = "Team tag for EC2 instances"
  default     = ["qa-em"]
}

variable "tag_owner" {
  type        = list(string)
  description = "Owner tag for EC2 instances"
  default     = ["em-akshay"]
}

variable "tag_cost_center" {
  description = "Cost center tag for EC2 instances"
  default     = "cc-1001"
}

variable "tag_application" {
  type        = list(string)
  description = "Application tag for EC2 instances"
  default     = ["customer-onboarding"]
}
