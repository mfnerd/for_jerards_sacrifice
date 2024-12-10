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
    vpc_cidr            = "10.180.0.0/16"
    public_subnet_cidr  = ["10.180.1.0/24", "10.180.2.0/24"]
    private_subnet_cidr = ["10.180.11.0/24", "10.180.12.0/24"]
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
    vpc_cidr            = "10.181.0.0/16"
    public_subnet_cidr  = ["10.181.1.0/24", "10.181.2.0/24"]
    private_subnet_cidr = ["10.181.11.0/24", "10.181.12.0/24"]
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
    vpc_cidr            = "10.184.0.0/16"
    public_subnet_cidr  = ["10.184.1.0/24", "10.184.2.0/24"]
    private_subnet_cidr = ["10.184.11.0/24", "10.184.12.0/24"]
  }
}

variable "brazil_config" {
  description = "Configuration for the brazil environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "sa-east-1"
    name                = "brazil"
    vpc_cidr            = "10.187.0.0/16"
    public_subnet_cidr  = ["10.187.1.0/24", "10.187.2.0/24"]
    private_subnet_cidr = ["10.187.11.0/24", "10.187.12.0/24"]
  }
}

variable "london_config" {
  description = "Configuration for the london environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "eu-west-2"
    name                = "london"
    vpc_cidr            = "10.183.0.0/16"
    public_subnet_cidr  = ["10.183.1.0/24", "10.183.2.0/24"]
    private_subnet_cidr = ["10.183.11.0/24", "10.183.12.0/24"]
  }
}

variable "hong_kong_config" {
  description = "Configuration for the hong_kong environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "ap-east-1"
    name                = "hong-kong"
    vpc_cidr            = "10.186.0.0/16"
    public_subnet_cidr  = ["10.186.1.0/24", "10.186.2.0/24"]
    private_subnet_cidr = ["10.186.11.0/24", "10.186.12.0/24"]
  }
}

variable "cali_config" {
  description = "Configuration for the cali environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "us-west-1"
    name                = "cali"
    vpc_cidr            = "10.185.0.0/16"
    public_subnet_cidr  = ["10.185.1.0/24", "10.185.2.0/24"]
    private_subnet_cidr = ["10.185.11.0/24", "10.185.12.0/24"]
  }
}

variable "osaka_config" {
  description = "Configuration for the osaka environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "ap-northeast-3"
    name                = "osaka"
    vpc_cidr            = "10.188.0.0/16"
    public_subnet_cidr  = ["10.188.1.0/24", "10.188.2.0/24"]
    private_subnet_cidr = ["10.188.11.0/24", "10.188.12.0/24"]
  }
}