output "ip_addresses" {
  value = flatten([local.ip_addresses])
}

