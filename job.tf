resource "rundeck_job" "lambda_job" {
  name         = "Lambda execute ${var.lambda_name}"
  project_name = var.rundeck_project_name
  group_name   = var.rundeck_group_name
  description  = "Executes the ${var.lambda_name} lambda."


  dynamic "option" {
    for_each = var.options
    iterator = each

    content {
      name        = each.value.name
      label       = each.value.label
      description = each.value.description
      required    = each.value.required
    }
  }

  command {
    description = "Write options as JSON"
    inline_script = <<-EOT
#!/bin/bash
echo '${jsonencode(var.options)}' > ${var.lambda_name}_options.json
  }


  command {
    description   = "Configure and execute the lambda"
    inline_script = <<-EOT
#!/usr/bin/python3

import boto3

client = boto3.client('lambda')
response = client.get_function_configuration(
    FunctionName='${var.lambda_name}'
)
previous_vars =  response['Environment']['Variables']

response = client.update_function_configuration(
    FunctionName='${var.lambda_name}',
    Environment=dict(Variables)
)
EOT
  }
}