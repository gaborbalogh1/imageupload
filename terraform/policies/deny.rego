package policy

import data.aws.serverless
import data.terraform
import data.terraform.module

deny contains msg if {
  msg := serverless.deny[_]
}

deny contains msg if {
  msg := terraform.deny[_]
}

deny contains msg if {
  msg := terraform.module.deny[_]
}

