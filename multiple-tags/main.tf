# main.tf
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {}
}

locals {
  aws_region_value    = try(tostring(tolist(var.aws_region)[0]), tostring(var.aws_region))
  aws_region_az_value = try(tostring(tolist(var.aws_region_az)[0]), tostring(var.aws_region_az))

  tag_project_values     = try([for v in tolist(var.tag_project) : tostring(v)], [tostring(var.tag_project)])
  tag_team_values        = try([for v in tolist(var.tag_team) : tostring(v)], [tostring(var.tag_team)])
  tag_owner_values       = try([for v in tolist(var.tag_owner) : tostring(v)], [tostring(var.tag_owner)])
  tag_application_values = try([for v in tolist(var.tag_application) : tostring(v)], [tostring(var.tag_application)])
  tag_cost_center_values = try([for v in tolist(var.tag_cost_center) : tostring(v)], [tostring(var.tag_cost_center)])

  # NEW: decode JSON string(s) from tag_akshay → flat map → AWS string tags
  tag_akshay_json_strings = try(
    length(tolist(var.tag_akshay)) > 0 ? [for v in tolist(var.tag_akshay) : trimspace(tostring(v))] : [trimspace(tostring(var.tag_akshay))],
    [trimspace(tostring(var.tag_akshay))]
  )
  tag_akshay_non_empty = [for s in local.tag_akshay_json_strings : s if s != "" && s != "{}"]
  tag_akshay_maps      = length(local.tag_akshay_non_empty) > 0 ? [for s in local.tag_akshay_non_empty : jsondecode(s)] : []
  tag_akshay_merged    = length(local.tag_akshay_maps) > 0 ? merge(local.tag_akshay_maps...) : {}
  tag_akshay_aws       = { for k, v in local.tag_akshay_merged : k => tostring(v) }
}

provider "aws" {
  region = local.aws_region_value
  default_tags {
    tags = {
      env   = "qa"
      email = "akshay@rafay.co"
    }
  }
}

resource "aws_instance" "ubuntu" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = local.aws_region_az_value

  tags = merge(
    {
      Name        = var.name
      env         = "qa"
      email       = var.email
      project     = join(",", local.tag_project_values)
      team        = join(",", local.tag_team_values)
      owner       = join(",", local.tag_owner_values)
      cost_center = join(",", local.tag_cost_center_values)
      application = join(",", local.tag_application_values)
    },
    local.tag_akshay_aws
  )

  volume_tags = {
    env   = "qa"
    email = "akshay@rafay.co"
  }
}

resource "aws_instance" "ubuntu-1" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = local.aws_region_az_value

  tags = merge(
    {
      Name        = var.name1
      env         = "qa"
      email       = var.email
      project     = join(",", local.tag_project_values)
      team        = join(",", local.tag_team_values)
      owner       = join(",", local.tag_owner_values)
      cost_center = join(",", local.tag_cost_center_values)
      application = join(",", local.tag_application_values)
    },
    local.tag_akshay_aws
  )

  volume_tags = {
    env   = "qa"
    email = "akshay@rafay.co"
  }

  depends_on = [aws_instance.ubuntu]
}

resource "aws_s3_bucket" "simple_bucket" {
  bucket = "${var.app_details[0]}-${var.app_details[1]}"

  tags = {
    Project     = var.app_details[0]
    Environment = var.app_details[1]
    Location    = var.app_details[2]
  }
}
