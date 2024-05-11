<img align="right" width="60" height="60" src="images/terraform.png">

# terraform-snowflake-pipes

Terraform Module for Managing Snowflake Pipes

- snowflake_pipe

This Terraform module is designed to manage a Snowflake pipe and its associated permissions.

Here's a summary of what each resource does:

1. `snowflake_pipe`: This resource creates a Snowflake pipe in the specified database and schema. The pipe is named according to the `name` variable. The `comment`, `copy_statement`, `auto_ingest`, `aws_sns_topic_arn`, and `notification_channel` variables are used to configure the pipe's settings.

- `auto_ingest`: determines whether the pipe will automatically ingest new files from the data source.
- `aws_sns_topic_arn`: specifies the Amazon Resource Name (ARN) of the SNS topic that will send notifications about new data files to ingest.
- `notification_channel`: specifies the channel that will receive notifications about the pipe's activities.
- `comment`: allows you to add a comment or description for the pipe.
- `copy_statement`: is the SQL statement that the pipe will use to copy data from the data source to the Snowflake database.

2. `snowflake_pipe_grant`: This resource manages the permissions for the Snowflake pipe. It grants the specified privilege to the roles specified in the `roles` variable. The - `on_future`, `with_grant_option`, and `enable_multiple_grants` variables are used to configure the grant's settings.

- `on_future`: determines whether the grant applies to future pipes in the schema.
- `with_grant_option`: allows the roles to grant the privilege to other roles.
- `enable_multiple_grants`: allows the privilege to be granted to the roles multiple times.

This module requires Terraform version 1.5.6 or later and uses the `null` and `snowflake` providers.

Example CICD with `BitBucket` and `Codefresh`:

![Image](./images/diagram.png)

## Notes

1. `Module Purpose`: This module is designed to manage a Snowflake pipe and its associated permissions. It provides a structured and reusable way to create and manage Snowflake pipes in a Terraform configuration.
2. `Configuration Flexibility`: The module allows for a high degree of customization of the Snowflake pipe and its permissions. You can configure automatic ingestion of new files, notification channels, custom copy statements, and more.
3. `Permissions Management`: The module manages the permissions for the Snowflake pipe, granting specified privileges to specified roles. It provides options to apply the grant to future pipes in the schema, allow the roles to grant the privilege to other roles, and enable the privilege to be granted to the roles multiple times.
4. `Terraform and Provider Versions`: This module requires Terraform version 1.5.6 or later. The functionality of the module may also depend on the version of the snowflake provider.
5. `Sensitive Data Handling`: Be careful with sensitive data like AWS and Snowflake credentials. Avoid hardcoding them in the Terraform configuration. Instead, use secure methods like environment variables or AWS Secrets Manager.
6. `Idempotency`: Terraform is designed to be idempotent, meaning running the same configuration multiple times should result in the same state. However, if manual changes are made outside of Terraform, it could cause discrepancies between the actual state and the state stored in the Terraform state file.
7. `Error Handling`: If the copy_statement in the pipe configuration encounters an error while copying data, the pipe's behavior depends on the ON_ERROR option in the copy_statement. Make sure to set this option according to your error handling requirements.

## Usage

The following shows some basic usages and advances usages on how to use the module to manage a `snowflake_pipe` with an associated `snowflake_pipe_grant`.

### Basic Usage

```terraform
module "snowflake_pipe" {
  source = "https://github.com/Richard-Barrett/terraform-snowflake-pipes"
  version = "0.0.1"

  # Pipe variables
  auto_ingest        = true
  aws_sns_topic_arn  = "arn:aws:sns:us-west-2:123456789012:my-topic"
  notification_channel = "arn:aws:sns:us-west-2:123456789012:my-channel"
  comment            = "This is my pipe"
  copy_statement     = "COPY INTO my_table FROM @my_stage"
  database           = "my_database"
  name               = "my_pipe"
  schema             = "my_schema"

  # Grant variables
  on_future             = true
  privilege             = "USAGE"
  roles                 = ["my_role"]
  with_grant_option     = false
  enable_multiple_grants = false
}
```

This configuration creates a Snowflake pipe named `my_pipe` in the `my_database.my_schema` schema. The pipe is configured to automatically ingest new files, and it uses the specified SNS topic and channel for notifications. The `USAGE` privilege is granted to `my_role`, and this grant applies to future pipes in the schema.

### Advanced Usage

The following is an advanced usage for the module

```hcl
module "snowflake_pipe" {
  source = "path/to/module"  # Replace with the actual source of the module

  # Pipe variables
  auto_ingest        = true
  aws_sns_topic_arn  = aws_sns_topic.my_topic.arn
  notification_channel = aws_sns_topic.my_channel.arn
  comment            = "This is my advanced pipe"
  copy_statement     = <<EOF
    COPY INTO my_advanced_table 
    FROM @my_advanced_stage 
    FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1)
    ON_ERROR = 'CONTINUE'
  EOF
  database           = aws_snowflake_database.my_db.name
  name               = "my_advanced_pipe"
  schema             = aws_snowflake_schema.my_schema.name

  # Grant variables
  on_future             = true
  privilege             = "USAGE"
  roles                 = [aws_snowflake_role.my_role.name]
  with_grant_option     = true
  enable_multiple_grants = true
}

resource "aws_sns_topic" "my_topic" {
  name = "my-topic"
}

resource "aws_sns_topic" "my_channel" {
  name = "my-channel"
}

resource "aws_snowflake_database" "my_db" {
  name = "my_database"
}

resource "aws_snowflake_schema" "my_schema" {
  name     = "my_schema"
  database = aws_snowflake_database.my_db.name
}

resource "aws_snowflake_role" "my_role" {
  name = "my_role"
}
```

In this example, replace "path/to/module" with the actual source of the module. The other values are just examples and should be replaced with your actual values.

This configuration creates an SNS topic, a Snowflake database, a Snowflake schema, and a Snowflake role, and then uses these resources to configure the Snowflake pipe. The pipe is configured to automatically ingest new files, and it uses the specified SNS topic and channel for notifications. The USAGE privilege is granted to the created role, and this grant applies to future pipes in the schema. The with_grant_option and enable_multiple_grants options are set to true, allowing the role to grant the privilege to other roles and the privilege to be granted to the role multiple times.

### Considerations

When using this Terraform module, users should be aware of the following considerations:

1. Permissions: The AWS and Snowflake credentials used to run this module need to have sufficient permissions to create and manage Snowflake pipes and grants.
2. Idempotency: Terraform is designed to be idempotent, meaning running the same configuration multiple times should result in the same state. However, if manual changes are made outside of Terraform, it could cause discrepancies between the actual state and the state stored in the Terraform state file.
3. Sensitive Data: Be careful with sensitive data like AWS and Snowflake credentials. Avoid hardcoding them in the Terraform configuration. Instead, use secure methods like environment variables or AWS Secrets Manager.
4. Error Handling: If the copy_statement in the pipe configuration encounters an error while copying data, the pipe's behavior depends on the ON_ERROR option in the copy_statement. Make sure to set this option according to your error handling requirements.
5. Future Grants: If on_future is set to true, the grant will apply to future pipes in the schema. This could potentially give more permissions than intended if new pipes are created in the schema without realizing that the grant applies to them.
6. Multiple Grants: If enable_multiple_grants is set to true, the privilege can be granted to the roles multiple times. This could potentially lead to confusion about the actual privileges of the roles.
7. Terraform Version: This module requires Terraform version 1.5.6 or later. Make sure to use a compatible version of Terraform.
8. Provider Version: The version of the snowflake provider used by this module could affect its functionality. If you encounter issues, try updating to the latest version of the snowflake provider.

## Overview

This Terraform module is designed to manage a Snowflake pipe and its associated permissions. 

A Snowflake pipe is a named object in Snowflake that defines a data stream from an external source. This module allows you to create such a pipe with various configurations like automatic ingestion of new files, notification channels, and a custom copy statement.

The module also manages the permissions for the Snowflake pipe. It grants specified privileges to specified roles. The module provides flexibility in terms of applying the grant to future pipes in the schema, allowing the roles to grant the privilege to other roles, and enabling the privilege to be granted to the roles multiple times.

In summary, this module provides a structured and reusable way to create and manage Snowflake pipes and their permissions in a Terraform configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.90.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | ~> 0.90.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [snowflake_pipe.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/pipe) | resource |
| [snowflake_pipe_grant.grant](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/pipe_grant) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_ingest"></a> [auto\_ingest](#input\_auto\_ingest) | A boolean that determines if the pipe will automatically ingest new files. | `bool` | `null` | no |
| <a name="input_aws_sns_topic_arn"></a> [aws\_sns\_topic\_arn](#input\_aws\_sns\_topic\_arn) | The Amazon Resource Name (ARN) of the SNS topic. | `string` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | A comment for the pipe. | `string` | `""` | no |
| <a name="input_copy_statement"></a> [copy\_statement](#input\_copy\_statement) | The COPY statement for the pipe. | `string` | n/a | yes |
| <a name="input_database"></a> [database](#input\_database) | The name of the database. | `string` | n/a | yes |
| <a name="input_enable_multiple_grants"></a> [enable\_multiple\_grants](#input\_enable\_multiple\_grants) | A boolean that determines if multiple grants are enabled. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the pipe. | `string` | n/a | yes |
| <a name="input_on_future"></a> [on\_future](#input\_on\_future) | ... | `bool` | `null` | no |
| <a name="input_privilege"></a> [privilege](#input\_privilege) | The privilege for the grant. | `string` | `"USAGE"` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | The roles for the grant. | `list(string)` | `[]` | no |
| <a name="input_schema"></a> [schema](#input\_schema) | The name of the schema. | `string` | `null` | no |
| <a name="input_with_grant_option"></a> [with\_grant\_option](#input\_with\_grant\_option) | A boolean that determines if the grant option is enabled. | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
