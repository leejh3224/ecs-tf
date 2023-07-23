module "backend" {
  source = "./modules/backend"

  common_tags = module.common.common_tags
}

module "common" {
  source = "./modules/common"

  organization = var.organization
  environment  = var.environment
  project      = var.project
  owner        = var.owner
}

module "ecr" {
  source = "./modules/ecr"

  common_tags     = module.common.common_tags
  resource_prefix = module.common.resource_prefix
  aws_account_id  = module.common.aws_account_id
  aws_region      = var.aws_region
}

module "ecs" {
  source = "./modules/ecs"

  common_tags                 = module.common.common_tags
  resource_prefix             = module.common.resource_prefix
  aws_region                  = var.aws_region
  container_name              = var.project
  public_subnet_ids           = module.network.public_subnet_ids
  sg_ecs_service_id           = module.security.sg_ecs_service_id
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  aws_ecr_repository_url      = module.ecr.aws_ecr_repository_url
  alb_target_group_arn        = module.loadbalancer.alb_target_group_arn
}

module "iam" {
  source = "./modules/iam"
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  common_tags       = module.common.common_tags
  resource_prefix   = module.common.resource_prefix
  sg_alb_id         = module.security.sg_alb_id
  public_subnet_ids = module.network.public_subnet_ids
  vpc_main_id       = module.network.vpc_main_id
}

module "network" {
  source = "./modules/network"

  common_tags          = module.common.common_tags
  cidr_vpc             = module.common.cidr_vpc
  cidr_anywhere        = module.common.cidr_anywhere
  cidr_public_one      = module.common.cidr_public_one
  cidr_public_two      = module.common.cidr_public_two
  az_subnet_public_one = "${var.aws_region}a"
  az_subnet_public_two = "${var.aws_region}c"
}

module "security" {
  source = "./modules/security"

  common_tags     = module.common.common_tags
  resource_prefix = module.common.resource_prefix
  cidr_anywhere   = module.common.cidr_anywhere
  vpc_main_id     = module.network.vpc_main_id
}
