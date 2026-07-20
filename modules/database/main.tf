resource "aws_db_subnet_group" "db_subnet" {
  name="${var.project_name}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags={
    Name = "${var.project_name}-db-subnets"
    Enviroment = var.environment
  }
}
resource "aws_db_instance" "rds" {
  identifier = "${var.project_name}-db"
  engine = "postgres"
  engine_version = "17.10"

  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot = true
  multi_az = false
  publicly_accessible = false
  tags={
    Name = "${var.project_name}-db"
    Enviroment = var.environment
  }
}