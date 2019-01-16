variable "heroku_email" {}
variable "heroku_api_key" {}

terraform {
  backend "gcs" {
    bucket  = "complimentary-terraform-state"
    prefix  = "incremental-todo"
  }
}

# Configure the Heroku provider
provider "heroku" {
  email   = "${var.heroku_email}"
  api_key = "${var.heroku_api_key}"
}

# Create a new application
resource "heroku_app" "incremental-todo" {
  name   = "incremental-todo"
  region = "us"
}

resource "heroku_addon" "redis" {
  app  = "${heroku_app.incremental-todo.name}"
  plan = "heroku-redis:hobby-dev"
}
