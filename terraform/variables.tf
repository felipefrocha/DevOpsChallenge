variable "project" {
  description = "This is the name of your application or your project"
  type        = string
  default     = "nibodevops"
}

variable "region" {
  description = "Region where your application showld be allocated"
  type        = string
  default     = "eastus"
}


variable "docker_passwd" {
  description = "This should be used local only"
  type        = string
}

variable "docker_username" {
  description = "This should be used local only"
  type        = string
}

