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