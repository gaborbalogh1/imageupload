package policy

import data.aws.serverless

deny[msg] {
  msg := serverless.deny[_]
}
