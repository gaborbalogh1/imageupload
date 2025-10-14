package policy

import data.aws.serverless

deny contains msg if {
  msg := serverless.deny[_]
}
