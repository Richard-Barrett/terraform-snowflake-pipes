# Complete

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.90.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_snowflake_pipe"></a> [snowflake\_pipe](#module\_snowflake\_pipe) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_notification_channel"></a> [notification\_channel](#input\_notification\_channel) | The notification channel for the pipe. | `string` | `"arn:aws:sns:us-west-2:123456789012:my-channel"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->