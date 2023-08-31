data "hsdp_config" "cf" {
  service = "cf"
}

module "caddy_proxy" {
  source      = "../../"
  cf_domain   = data.hsdp_config.cf.domain
  cf_space_id = "test"

  upstream_app_id = "a"
  upstream_url    = "http://foo.apps.internal:8080"
  name_postfix    = "default-example"
}
