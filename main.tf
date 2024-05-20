terraform {
  required_version = ">= 1.5.6"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.91.0"
    }
  }
}

resource "snowflake_pipe" "this" {
  database = var.database
  schema   = var.schema
  name     = var.name

  comment = var.comment

  copy_statement = var.copy_statement
  auto_ingest    = var.auto_ingest

  aws_sns_topic_arn = var.aws_sns_topic_arn
}

resource "snowflake_pipe_grant" "grant" {
  database_name = var.database
  schema_name   = var.schema
  pipe_name     = snowflake_pipe.this.name

  privilege = var.privilege
  roles     = var.roles // Example: ["role1", "role2"]

  on_future              = var.on_future
  with_grant_option      = var.with_grant_option
  enable_multiple_grants = var.enable_multiple_grants
}