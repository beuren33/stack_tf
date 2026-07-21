output "alb_dns_name" {
  value = module.loadbalancer.alb_dns_name
}

output "db_endpoint" {
  value = module.database.db_endpoint
}