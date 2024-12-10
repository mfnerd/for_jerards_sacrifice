provider "aws" {
  alias  = "new_york"
  region = var.new_york_config.region
}


variable "new_york_config" {
  description = "Configuration for the new_york environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "us-east-1"
    name                = "new-york"
    vpc_cidr            = "10.161.0.0/16"
    public_subnet_cidr  = ["10.161.1.0/24", "10.161.2.0/24"]
    private_subnet_cidr = ["10.161.11.0/24", "10.161.12.0/24"]
  }
}

module "new_york_network" {
  source              = "./modules/network"
  region              = var.new_york_config.region
  name                = var.new_york_config.name
  vpc_cidr            = var.new_york_config.vpc_cidr
  public_subnet_cidr  = var.new_york_config.public_subnet_cidr
  private_subnet_cidr = var.new_york_config.private_subnet_cidr
  tgw_id              = module.new_york_tgw_branch.tgw_id
}

module "new_york_frontend" {
  source            = "./modules/frontend"
  region            = var.new_york_config.region
  name              = var.new_york_config.name
  vpc_id            = module.new_york_network.vpc_id
  public_subnet_ids = module.new_york_network.public_subnet_ids
  target_group_arn  = module.new_york_backend.target_group_arn
}

module "new_york_backend" {
  source = "./modules/backend"

  region                = var.new_york_config.region
  name                  = var.new_york_config.name
  vpc_id                = module.new_york_network.vpc_id
  private_subnet_ids    = module.new_york_network.private_subnet_ids
  frontend_sg_id        = module.new_york_frontend.frontend_sg_id
  backend_instance_type = var.backend_config.backend_instance_type[0]
  desired_capacity      = var.backend_config.desired_capacity
  scaling_range         = var.backend_config.scaling_range
  user_data             = var.backend_config.user_data
}

module "new_york_tgw_branch" {
  source = "./modules/tgw_branch"
  providers = {
    aws.default = aws.new_york
    aws.tokyo  = aws.tokyo
  }

  region             = var.new_york_config.region
  name               = var.new_york_config.name
  vpc_id             = module.new_york_network.vpc_id
  private_subnet_ids = module.new_york_network.private_subnet_ids
  peer_tgw_id        = aws_ec2_transit_gateway.tokyo.id
}