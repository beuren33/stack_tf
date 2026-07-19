variable "project_name"{
    type= string
    default= "basic_stack_tf"
}
variable "environment"{
    type= string
    default= "dev"
}
variable "vpc_cidr" {
    type= string
    default= "10.0.0.0/16"
}
variable "public_subnets_cidrs" {
    type= list(string)
    default= ["10.0.1.0/24",  "10.0.2.0/24"]
}
variable "private_app_subnets_cidrs" {
    type= list(string)
    default= ["10.0.11.0/24", "10.0.12.0/24"]
}
variable "private_db_subnets_cidrs" {
    type= list(string)
    default= ["10.0.21.0/24", "10.0.22.0/24"]
}
variable "availability_zones" {
    type = list(string)
    default= ["us-east-1a", "us-east-1b"]
}