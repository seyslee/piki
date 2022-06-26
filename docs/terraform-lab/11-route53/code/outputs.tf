output "ns-servers" {
  value = aws_route53_zone.terraform-training.name_servers
}
