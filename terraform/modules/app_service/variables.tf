variable "resource_group_name" {
  description = "The name of the resource group in which to create the PostgreSQL Server. Changing this forces a new resource to be created."
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "environment" {
  description = "This variable should indicate wich environment is being considered to this database"
}

variable "project" {
  description = "The name of the actual app or project in which this resource will be allocated"
}

variable "docker_username" {
  description = "ACR endpoint name"
}

variable "image_name" {
  description = "The name of the image to be mounted"
  type = list(object({
    name   = string
    port   = number
    image  = string
    health = string
  }))

}

variable "username" {
  description = "The name of the image to be mounted"
  type        = string
}

variable "password" {
  description = "The name of the image to be mounted"
  type        = string
}

variable "size_app" {
  description = "This describe the size of the application for the next environment"
  type = object({
    tier = string
    size = string
  })

  validation {
    condition     = can(regex("(Basic)|(Standard)|(Premium)", var.size_app.tier)) && can(regex("(B[1-3])|(S[1-3])|(P[1-3])", var.size_app.size))
    error_message = "The tier should be Basic, Standard or Premium and sizes should be B13 or S13 and P13."
  }
}