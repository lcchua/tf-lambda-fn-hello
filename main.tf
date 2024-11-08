# Example A: Deplpoyong serverless applications with AWS Lambda with Terraform 
# resource or module. The current default uses Terrafrom resource.
#     https://spacelift.io/blog/terraform-aws-lambda 
# Example B: Deploying serverless applications with AWS Lambda and API Gateway.
# This uses S3 for archive storage of the zipped Lambda appl program instead of 
# just storing in a local directory which is less safe.
#     https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway 
# This current default combines the examples A & B by creating an AWS API Gateway
# and linking it to the "hello" Lambda function program via a HTTP API call.
# Refer api_gateway.tf.

resource "random_string" "unique_suffix" {
  length  = 6
  special = false
}

# Uncomment this block if we are to use AWS Lambda Terraform module 
# instead of Terraform resource. The only difference is that the permissions 
# are slightly different, and the archive is created using a null resource 
# with a local-exec provisioner that runs a Python script.
# If uncomment this block below to use Terraform module instead, then just
# comment out the remaining lines of codes from line 30 inwards.
/*
module "lambda" {
 source        = "terraform-aws-modules/lambda/aws"
 version       = "7.8.1"
 function_name = "hello"
 description   = "My awesome lambda function"
 handler       = "hello.lambda_handler"
 runtime       = "python3.12"

 source_path = "./hello.py"
}
*/

resource "aws_iam_role" "lambdafn_iam_role" {
  name               = "lcchua-stw-lambdafn-role-${random_string.unique_suffix.result}"
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
  name        = "lcchua-stw-lambdafn-policy-${random_string.unique_suffix.result}"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
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
  role = aws_iam_role.lambdafn_iam_role.name
  #policy_arn  = aws_iam_policy.lambdafn_iam_policy.arn
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
}

resource "aws_lambda_function" "tf_lambda_func" {
  filename         = "${path.module}/python/hello-python.zip"
  function_name    = "lcchua-stw-lambda-fn-hello-${random_string.unique_suffix.result}"
  role             = aws_iam_role.lambdafn_iam_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.zip_the_python_code.output_base64sha256
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/lcchua-hello-${random_string.unique_suffix.result}"
  retention_in_days = 14
}