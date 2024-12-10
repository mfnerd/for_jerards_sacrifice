variable "backend_config" {
  description = "Configuration for the backend module"
  type = object({
    backend_instance_type = list(string)
    desired_capacity      = number
    scaling_range         = list(number)
    user_data             = string
  })

  default = {
    backend_instance_type = ["t2.micro", "t3.micro"]
    desired_capacity      = 2
    scaling_range         = [1, 3]
    user_data             = "./scripts/startup.sh"
  }
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

variable "sydney_config" {
  description = "Configuration for the sydney environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "ap-southeast-2"
    name                = "sydney"
    vpc_cidr            = "10.164.0.0/16"
    public_subnet_cidr  = ["10.164.1.0/24", "10.164.2.0/24"]
    private_subnet_cidr = ["10.164.11.0/24", "10.164.12.0/24"]
  }
}