module "networking" {
  source = "../../modules/networking"

  project_name = var.project_name
  environment = var.environment
  vpc_cidr = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets_cidrs = var.public_subnets_cidrs
  private_app_subnets_cidrs = var.private_app_subnets_cidrs
  private_db_subnets_cidrs = var.private_db_subnets_cidrs
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment = var.environment
  vpc_id = module.networking.vpc_id
}

module "database" {
  source = "../../modules/database"

  project_name = var.project_name
  environment = var.environment
  private_db_subnet_ids = module.networking.private_db_ids
  rds_security_group_id = module.security.rds_security_group_id
  db_username = var.db_username
  db_password = var.db_password
  db_name = var.db_name
  db_instance_class = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
}

module "compute" {
  source = "../../modules/compute"

  project_name = var.project_name
  environment = var.environment
  private_app_subnet_ids = module.networking.private_app_ids
  ec2_security_group_id = module.security.ec2_security_group_id
  instance_type = var.instance_type
  ami_id = var.ami_id
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
}

module "loadbalancer" {
  source = "../../modules/loadbalancer"

  project_name = var.project_name
  environment = var.environment
  vpc_id = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnets_ids
  alb_security_group_id = module.security.alb_security_group_id
  autoscaling_group_id = module.compute.autoscaling_group_id
}