terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {}
locals {
  read_only = ["read_only_user_1", "read_only_user_2", "read_only_user_3"]
}

resource "aws_iam_user" "read_only" {
  for_each = toset(local.read_only)
  name     = each.value
}
resource "aws_iam_group" "read_only" {
   name = "read_only"
}
resource "aws_iam_group_membership" "read" {
   name = "read_only-group-membership"
   users = local.read_only

   group = aws_iam_group.read_only.name
}
resource "aws_iam_group_policy_attachment" "read_only_policy" {
   group      = aws_iam_group.read_only.name
   policy_arn = "arn:aws:iam::aws:policy/AmazonConnectReadOnlyAccess"
}