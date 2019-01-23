variable "heroku_email" {}
variable "heroku_api_key" {}
variable "gcs_credential_file" {}

terraform {
  backend "gcs" {
    bucket  = "complimentary-terraform-state"
    prefix  = "incremental-todo"
  }
}

# Heroku: app, DBs
provider "heroku" {
  email   = "${var.heroku_email}"
  api_key = "${var.heroku_api_key}"
}

resource "heroku_app" "incremental-todo" {
  name   = "incremental-todo"
  region = "us"
}

resource "heroku_addon" "redis" {
  app  = "${heroku_app.incremental-todo.name}"
  plan = "heroku-redis:hobby-dev"
}

# GCP: object storage
provider "google" {
  credentials = "${var.gcs_credential_file}"
  project     = "incremental-todo"
  region      = "us-central1"
}

resource "google_storage_bucket" "incremental-todo-image-store" {
  name          = "incremental-todo-image-store"
  location      = "us-central1"
  storage_class = "REGIONAL"
  force_destroy = true

  cors {
      method = ["*"]
      origin = ["https://incremental-todo.herokuapp.com"]
      response_header = ["Content-Type", "Content-MD5"]
      max_age_seconds = 3000
  }
}

