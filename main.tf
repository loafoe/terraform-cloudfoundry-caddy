resource "cloudfoundry_app" "caddy_proxy" {
  name         = "tf-caddy-proxy-${var.name_postfix}"
  space        = var.cf_space_id
  memory       = 128
  disk_quota   = 512
  docker_image = var.caddy_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }

  environment = merge({
    CADDYFILE_BASE64 = base64encode(templatefile("${path.module}/templates/Caddyfile", {
      upstream_url = var.upstream_url
      headers      = var.headers
    }))
  }, {})

  command           = "echo $CADDYFILE_BASE64 | base64 -d > /etc/caddy/Caddyfile && cat /etc/caddy/Caddyfile && caddy run --config /etc/caddy/Caddyfile"
  health_check_type = "process"
  strategy          = "rolling"

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.caddy_proxy.id
  }
}

resource "cloudfoundry_route" "caddy_proxy" {
  domain   = data.cloudfoundry_domain.internal.id
  space    = var.cf_space_id
  hostname = "tf-caddy-proxy-${var.name_postfix}"
}

resource "cloudfoundry_network_policy" "caddy_proxy" {

  policy {
    source_app      = cloudfoundry_app.caddy_proxy.id
    destination_app = var.upstream_app_id
    protocol        = "tcp"
    port            = var.upstream_port
  }

  policy {
    source_app      = var.downstream_app_id
    destination_app = cloudfoundry_app.caddy_proxy.id
    protocol        = "tcp"
    port            = "8080"
  }
}
