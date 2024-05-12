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

variable "notification_channel" {
  description = "The notification channel for the pipe."
  type        = string
  default     = "arn:aws:sns:us-west-2:123456789012:my-channel"
  
}
module "snowflake_pipe" {
  source = "../.." # Path to the root of the snowflake-pipe module

  # Pipe variables
  auto_ingest          = true
  aws_sns_topic_arn    = "arn:aws:sns:us-west-2:123456789012:my-topic"
  comment              = "This is my pipe"

  copy_statement = <<EOF
    COPY INTO my_table 
    FROM @my_stage 
    FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1)
    ON_ERROR = 'CONTINUE'
    NOTIFY = '${var.notification_channel}'
  EOF

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
