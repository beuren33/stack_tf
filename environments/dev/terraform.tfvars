project_name = "basic-stack"
environment = "dev"

vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_app_subnets_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
private_db_subnets_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]

db_username = "appadmin"
db_name = "basicstackdb"
db_instance_class = "db.t3.micro"
db_allocated_storage = 20

instance_type = "t3.micro"
ami_id = "ami-0b6d9d3d33ba97d99"
min_size = 1
max_size = 1
desired_capacity = 1