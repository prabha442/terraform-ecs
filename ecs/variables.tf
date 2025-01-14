variable "aws_region" {
  default     = "us-east-1"
  description = "aws region where our resources going to create choose"
  #replace the region as suits for your requirement
}


variable "ecs_task_execution_role" {
  default     = "myEcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "app_name" {
  type        = string
  default     = "sample-app"
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  default     = "pre-prod"
  description = "Application Environment"
}

variable "public_subnets" {
  type        = list
  default     = ["10.10.100.0/24", "10.10.101.0/24"]
  description = "List of public subnets"
}

variable "private_subnets" {
  type        = list
  default     = ["10.10.0.0/24", "10.10.1.0/24"]
  description = "List of private subnets"
}

variable "app_image" {
  default     = "357435718345.dkr.ecr.us-east-1.amazonaws.com/sampleapp:latest"
  description = "docker image to run in this ECS cluster"
}

variable "availability_zones" {
  type        = list
  default     = ["us-east-1a", "us-east-1b"]
  description = "List of availability zones"
}

variable "app_port" {
  default     = "80"
  description = "portexposed on the docker image"
}

variable "app_count" {
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate_memory" {
  default     = "2048"
  description = "Fargate instance memory to provision (in MiB) not MB"
}
