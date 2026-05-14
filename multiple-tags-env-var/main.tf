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
  aws_region_value    = trimspace(var.aws_region)
  aws_region_az_value = trimspace(var.aws_region_az)

  app_details_list = var.app_details

  tag_project_values     = can(jsondecode(var.tag_project)) ? jsondecode(var.tag_project) : [var.tag_project]
  tag_team_values        = can(jsondecode(var.tag_team)) ? jsondecode(var.tag_team) : [var.tag_team]
  tag_owner_values       = can(jsondecode(var.tag_owner)) ? jsondecode(var.tag_owner) : [var.tag_owner]
  tag_application_values = can(jsondecode(var.tag_application)) ? jsondecode(var.tag_application) : [var.tag_application]
  tag_cost_center_values = [trimspace(var.tag_cost_center)]

  # Decode each escaped JSON string value → re-encode as clean compact JSON
  tag_akshay_aws = {
    for k, v in var.tag_akshay : k => jsonencode(jsondecode(v))
  }
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
  bucket = "${local.app_details_list[0]}-${local.app_details_list[1]}"

  tags = {
    Project     = local.app_details_list[0]
    Environment = local.app_details_list[1]
    Location    = local.app_details_list[2]
  }
}
