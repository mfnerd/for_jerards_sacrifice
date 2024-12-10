provider "aws" {
  alias  = "tokyo"
  region = var.tokyo_config.region
}


variable "tokyo_config" {
  description = "Configuration for the tokyo environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "ap-northeast-1"
    name                = "tokyo"
    vpc_cidr            = "10.160.0.0/16"
    public_subnet_cidr  = ["10.160.1.0/24", "10.160.2.0/24"]
    private_subnet_cidr = ["10.160.11.0/24", "10.160.12.0/24"]
  }
}

module "tokyo_network" {
  source              = "./modules/network"
  region              = var.tokyo_config.region
  name                = var.tokyo_config.name
  vpc_cidr            = var.tokyo_config.vpc_cidr
  public_subnet_cidr  = var.tokyo_config.public_subnet_cidr
  private_subnet_cidr = var.tokyo_config.private_subnet_cidr
  tgw_id              = aws_ec2_transit_gateway.tokyo.id
}

module "tokyo_frontend" {
  source            = "./modules/frontend"
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

#######transit gateway##########

resource "aws_ec2_transit_gateway" "tokyo" {
  provider    = aws.tokyo
  description = "Tokyo Transit Gateway"
  tags = {
    Name = "tokyo-transit-gateway"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo" {
  provider           = aws.tokyo
  transit_gateway_id = aws_ec2_transit_gateway.tokyo.id
  vpc_id             = module.tokyo_network.vpc_id
  subnet_ids         = module.tokyo_network.private_subnet_ids
}

data "aws_caller_identity" "tokyo" {
  provider = aws.tokyo
}

#########tgw route table##########

data "aws_ec2_transit_gateway_route_table" "tokyo" {
  provider = aws.tokyo

  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.tokyo.id]
  }

  tags = {
    Name = "tgw-rtb-${var.tokyo_config.name}"
  }

  depends_on = [aws_ec2_transit_gateway.tokyo]
}

# resource "aws_ec2_transit_gateway_route" "to_new_york" {
#   provider                       = aws.tokyo
#   destination_cidr_block         = var.new_york_config.vpc_cidr
#   transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tokyo.id
#   transit_gateway_attachment_id  = ""
# }

# resource "aws_ec2_transit_gateway_peering_attachment" "tokyo_to_new_york" {
#   provider                = aws.tokyo
#   peer_region             = var.new_york_config.region
#   peer_transit_gateway_id = ""
#   transit_gateway_id      = aws_ec2_transit_gateway.tokyo.id
#   tags = {
#     Name = "$[var.tokyo_config.name}-to-$[var.new_york_config.name]"
#   }
# }
