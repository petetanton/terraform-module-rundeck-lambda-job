resource aws_iam_policy "exec" {
  name = "rundeck-lambda-execute-${var.lambda_name}"
  path = "/"
  policy = data.aws_iam_policy_document.exec.json
}

data "aws_iam_policy_document" "exec" {
  statement {
    actions = [
      "lambda:GetFunctionConfiguration",
      "lambda:UpdateFunctionConfiguration",
      "lambda:InvokeFunction",
    ]

    resources = [data.aws_lambda_function.lambda_function.arn]
  }

}

data "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_name
}