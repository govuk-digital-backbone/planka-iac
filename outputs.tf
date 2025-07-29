# output the Route53 name servers for the created Route53 zone
output "planka_route53_zone_name_servers" {
  value = try(aws_route53_zone.zone[0].name_servers, [])
}
