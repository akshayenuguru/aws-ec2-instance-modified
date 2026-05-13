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

  # tag_akshay: EM may send map/object, JSON string, or list of maps / list of JSON strings
  tag_akshay_merged = try(
    { for k, v in tomap(var.tag_akshay) : k => tostring(v) },
    try(
      { for k, v in jsondecode(trimspace(tostring(var.tag_akshay))) : k => tostring(v) },
      try(
        merge([
          for item in tolist(var.tag_akshay) :
          coalesce(
            try({ for k, v in tomap(item) : k => tostring(v) }, null),
            try({ for k, v in jsondecode(trimspace(tostring(item))) : k => tostring(v) }, null),
            {}
          )
        ]...),
        {}
      )
    )
  )

  tag_akshay_aws = local.tag_akshay_merged
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
    Project     = var.app_details[0]
    Environment = var.app_details[1]
    Location    = var.app_details[2]
  }
}
