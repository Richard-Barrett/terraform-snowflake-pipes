terraform {
  required_version = ">= 1.5.6"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.90.0"
    }
  }
}

provider "snowflake" {}

module "snowflake_pipe" {
  source = "../.." # Path to the root of the snowflake-pipe module

  # Pipe variables
  auto_ingest          = true
  aws_sns_topic_arn    = "arn:aws:sns:us-west-2:123456789012:my-topic"
  notification_channel = "arn:aws:sns:us-west-2:123456789012:my-channel"
  comment              = "This is my pipe"
  copy_statement       = "COPY INTO my_table FROM @my_stage"
  database             = "my_database"
  name                 = "my_pipe"
  schema               = "my_schema"

  # Grant variables
  on_future              = true
  privilege              = "USAGE"
  roles                  = ["my_role"]
  with_grant_option      = false
  enable_multiple_grants = false
}
