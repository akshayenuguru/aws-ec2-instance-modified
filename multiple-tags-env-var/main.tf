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

  # app_details arrives as a JSON string — jsondecode IS needed
  app_details_list = jsondecode(var.app_details)

  # tag_* vars are now native list(string) — no jsondecode needed
  tag_project_values     = var.tag_project
  tag_team_values        = var.tag_team
  tag_owner_values       = var.tag_owner
  tag_application_values = var.tag_application
  tag_cost_center_values = [var.tag_cost_center]

  # tag_akshay arrives as native map — no jsondecode needed
  tag_akshay_aws         = var.tag_akshay
  tag_akshay_json_string = jsonencode(var.tag_akshay)
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
      Name           = var.name
      env            = "qa"
      email          = var.email
      project        = join(",", local.tag_project_values)
      team           = join(",", local.tag_team_values)
      owner          = join(",", local.tag_owner_values)
      cost_center    = join(",", local.tag_cost_center_values)
      application    = join(",", local.tag_application_values)
      tag_akshay_raw = local.tag_akshay_json_string
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
      Name           = var.name1
      env            = "qa"
      email          = var.email
      project        = join(",", local.tag_project_values)
      team           = join(",", local.tag_team_values)
      owner          = join(",", local.tag_owner_values)
      cost_center    = join(",", local.tag_cost_center_values)
      application    = join(",", local.tag_application_values)
      tag_akshay_raw = local.tag_akshay_json_string
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
