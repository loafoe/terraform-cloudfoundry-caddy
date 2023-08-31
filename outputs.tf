output "proxy_endpoint" {
  description = "The Caddy proxy endpoint"
  value       = cloudfoundry_route.caddy_proxy.endpoint
}
