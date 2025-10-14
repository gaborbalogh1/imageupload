package terraform.deny

deny[msg] { msg := data.terraform.aws_s3.deny[_] }
deny[msg] { msg := data.terraform.aws_sg.deny[_] }
deny[msg] { msg := data.terraform.aws_iam.deny[_] }
deny[msg] { msg := data.terraform.aws_ebs.deny[_] }
deny[msg] { msg := data.terraform.aws_rds.deny[_] }
deny[msg] { msg := data.terraform.aws_lambda.deny[_] }
deny[msg] { msg := data.terraform.aws_serverless.deny[_] }
deny[msg] { msg := data.terraform.aws_cicd.deny[_] }
deny[msg] { msg := data.terraform.aws_ssm.deny[_] }
deny[msg] { msg := data.terraform.aws_asg.deny[_] }

