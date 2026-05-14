variable "app_details" {
  type        = string
  description = "JSON-encoded string of list: [\"project\",\"env\",\"location\"]"
  default     = "[\"takedaproject\",\"envmgr\",\"india\"]"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_region_az" {
  type    = string
  default = "us-east-1b"
}

variable "ami_id" {
  type    = string
  default = "ami-0854e54abaeae283b"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "name" {
  type    = string
  default = "akshay1-infra-provisioner"
}

variable "name1" {
  type    = string
  default = "akshay2-infra-provisioner"
}

variable "email" {
  type    = string
  default = "akshay@rafay.co"
}

variable "tag_project" {
  type    = string
  default = "customer-takeda"
}

variable "tag_team" {
  type    = string
  default = "qa-em"
}

variable "tag_owner" {
  type    = string
  default = "em-akshay"
}

variable "tag_cost_center" {
  type    = string
  default = "cc-1001"
}

variable "tag_application" {
  type    = string
  default = "customer-onboarding"
}

variable "tag_akshay" {
  type        = map(string)
  description = "Resolved map from restrictedKeyValues: { key1 = jsonString, key2 = jsonString }"
  default     = {}
}
