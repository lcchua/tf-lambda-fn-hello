# Example of deploying serverless applications with AWS Lambda and API Gateway
#     https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway 
provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_role" "lambdafn_iam_role" {
    name   = "lcchua-stw-lambdafn-role"
    assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF
}

resource "aws_iam_policy" "lambdafn_iam_policy" {
    name         = "lcchua-stw-lambdafn-iam-policy"
    path         = "/"
    description  = "AWS IAM Policy for managing aws lambda role"
    policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": "arn:aws:logs:*:*:*",
          "Effect": "Allow"
        }
      ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
    role        = aws_iam_role.lambdafn_iam_role.name
    policy_arn  = aws_iam_policy.lambdafn_iam_policy.arn
}

data "archive_file" "zip_the_python_code" {
    type        = "zip"
    source_dir  = "${path.module}/python/"
    output_path = "${path.module}/python/hello-python.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
    filename        = "${path.module}/python/hello-python.zip"
    function_name   = "lcchua-stw-lambda-fn-hello"
    role            = aws_iam_role.lambdafn_iam_role.arn
    handler         = "index.lambda_handler"
    runtime         = "python3.12"
    depends_on      = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}
