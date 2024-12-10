provider "aws" {
  alias  = "tokyo"
  region = var.tokyo_config.region
}

module "tokyo_network" {
  source = "./modules/network"

  region              = var.tokyo_config.region
  name                = var.tokyo_config.name
  vpc_cidr            = var.tokyo_config.vpc_cidr
  public_subnet_cidr  = var.tokyo_config.public_subnet_cidr
  private_subnet_cidr = var.tokyo_config.private_subnet_cidr
  tgw_id              = module.tgw_hq.tgw_id
}

module "tokyo_frontend" {
  source = "./modules/frontend"

  region            = var.tokyo_config.region
  name              = var.tokyo_config.name
  vpc_id            = module.tokyo_network.vpc_id
  public_subnet_ids = module.tokyo_network.public_subnet_ids
  target_group_arn  = module.tokyo_backend.target_group_arn
}

module "tokyo_backend" {
  source = "./modules/backend"

  region                = var.tokyo_config.region
  name                  = var.tokyo_config.name
  vpc_id                = module.tokyo_network.vpc_id
  private_subnet_ids    = module.tokyo_network.private_subnet_ids
  frontend_sg_id        = module.tokyo_frontend.frontend_sg_id
  backend_instance_type = var.backend_config.backend_instance_type[0]
  desired_capacity      = var.backend_config.desired_capacity
  scaling_range         = var.backend_config.scaling_range
  user_data             = var.backend_config.user_data
}

module "tgw_hq" {
  source = "./modules/tgw_hq"

  region             = var.tokyo_config.region
  vpc_id             = module.tokyo_network.vpc_id
  private_subnet_ids = module.tokyo_network.private_subnet_ids
}

