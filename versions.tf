terraform {
  required_version = ">= 1.5.0"

  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = ">= 0.50.0"
    }
  }
}
