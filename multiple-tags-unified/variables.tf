variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "aws_region_az" {
  type        = string
  description = "AWS availability zone"
  default     = "us-east-1a"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
  default     = "ami-0854e54abaeae283b"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "name" {
  type        = string
  description = "Name tag for first EC2 instance"
  default     = "akshay1-infra-provisioner"
}

variable "name1" {
  type        = string
  description = "Name tag for second EC2 instance"
  default     = "akshay2-infra-provisioner"
}

variable "email" {
  type        = string
  description = "Owner email address"
  default     = "akshay@rafay.co"
}

variable "app_details" {
  type        = list(string)
  description = "App identity list: [project, env, location]. Rafay: restricted multiSelect"
  default     = ["takedaproject", "envmgr", "india"]
}

variable "cost_allocation_tags" {
  type        = map(string)
  description = "Cost allocation tags. Rafay: restricted_key_values multiSelect. Each key maps to a JSON string of dept metadata"
  default     = {}
}

variable "tag_project" {
  type        = string
  description = "Project tag. Rafay: TF_VAR_tag_project. Single or multi-select JSON string"
  default     = "proj-alpha"
}

variable "tag_team" {
  type        = string
  description = "Team tag. Rafay: TF_VAR_tag_team. Single or multi-select JSON string"
  default     = "team-platform"
}

variable "tag_owner" {
  type        = string
  description = "Owner tag. Rafay: TF_VAR_tag_owner. Single or multi-select JSON string"
  default     = "owner-john"
}

variable "tag_application" {
  type        = string
  description = "Application tag. Rafay: TF_VAR_tag_application. Single or multi-select JSON string"
  default     = "app-payments"
}

variable "tag_data_classification" {
  type        = string
  description = "Data classification tag. Rafay: TF_VAR_tag_data_classification. Single value only"
  default     = "internal"
}

variable "environment_type" {
  type        = string
  description = "Environment tier. Rafay: TF_VAR_environment_type."
  default     = "prod"
}
