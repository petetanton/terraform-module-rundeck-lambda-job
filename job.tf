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
EOT
  }


  command {
    description   = "Configure and execute the lambda"
    inline_script = <<-EOT
#!/usr/bin/python3

import json
import boto3
import os

f = open('${var.lambda_name}_options.json')
options = json.load(f)

client = boto3.client('lambda')
response = client.get_function_configuration(
    FunctionName='${var.lambda_name}'
)
previous_vars =  response['Environment']['Variables']


new_vars = {}
for option in options:
  value = os.getenv(f"RD_OPTION_{option['name']}")
  new_vars[option['name']] = value

print(f'updating with vars: {new_vars}')

response = client.update_function_configuration(
    FunctionName='${var.lambda_name}',
    Environment=new_vars
)
EOT
  }
}