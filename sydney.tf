provider "aws" {
  alias  = "sydney"
  region = var.sydney_config.region
}

module "sydney_network" {
  source = "./modules/network"

  region              = var.sydney_config.region
  name                = var.sydney_config.name
  vpc_cidr            = var.sydney_config.vpc_cidr
  public_subnet_cidr  = var.sydney_config.public_subnet_cidr
  private_subnet_cidr = var.sydney_config.private_subnet_cidr
  tgw_id              = module.sydney_tgw_branch.tgw_id
}

module "sydney_frontend" {
  source = "./modules/frontend"

  region            = var.sydney_config.region
  name              = var.sydney_config.name
  vpc_id            = module.sydney_network.vpc_id
  public_subnet_ids = module.sydney_network.public_subnet_ids
  target_group_arn  = module.sydney_backend.target_group_arn
}

module "sydney_backend" {
  source = "./modules/backend"

  region                = var.sydney_config.region
  name                  = var.sydney_config.name
  vpc_id                = module.sydney_network.vpc_id
  private_subnet_ids    = module.sydney_network.private_subnet_ids
  frontend_sg_id        = module.sydney_frontend.frontend_sg_id
  backend_instance_type = var.backend_config.backend_instance_type[0]
  desired_capacity      = var.backend_config.desired_capacity
  scaling_range         = var.backend_config.scaling_range
  user_data             = var.backend_config.user_data
}

module "sydney_tgw_branch" {
  source = "./modules/tgw_branch"

  providers = {
    aws.default = aws.sydney
    aws.tokyo   = aws.tokyo
  }

  region             = var.sydney_config.region
  name               = var.sydney_config.name
  vpc_id             = module.sydney_network.vpc_id
  private_subnet_ids = module.sydney_network.private_subnet_ids
  peer_tgw_id        = module.tgw_hq.tgw_id
}