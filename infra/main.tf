variable "name" {}
variable "env" {}
variable "profile" {}
variable "git_organization" {}
variable "git_repo" {}
variable "git_branch" {}
variable "github_token" {}
variable "aws_region" {}
variable "aws_main_az" {}
variable "aws_account_id" {}

terraform {
  backend "s3" {
    bucket = "ruist-dev"
    workspace_key_prefix = "tf_state"
    region = "us-west-2"
    key = "state"
    encrypt = true
    dynamodb_table = "TerraformStates"
  }
}

module "build-pipeline" {
  source = "git::git@github.com:Ruist/infra-codebuild.git"

  env = "${var.env}"
  profile = "${var.profile}"
  aws_region = "${var.aws_region}"
  aws_account_id = "${var.aws_account_id}"
  aws_availability_zone = "${var.aws_main_az}"
  project_name = "${var.name}"
  git_organization = "${var.git_organization}"
  git_repo = "${var.git_repo}"
  git_branch = "${var.git_branch}"
  github_token = "${var.github_token}"
  deploy_docker = "false"
  image = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/node-dind-${var.aws_region}:latest"
}

output "artifact_bucket_name" {
  value = "${module.build-pipeline.artifact_bucket_name}"
}
