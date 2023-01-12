variable "lambda_name" {
  type = string
}

variable "rundeck_group_name" {
  type = string
}

variable "rundeck_project_name" {
  type = string
}

variable "options" {
  type        = list(object({name=string, label=string, description=string, required=bool, unset_after=bool}))
  description = "Set options that will be passed to the lambda"
  default     = []
}

variable "pass_options_as_env" {
  type = bool
  description = "if true, will pass the options into the Lambda function as environment variables."
}

variable "rundeck_iam_role_arn" {
  type = string
}