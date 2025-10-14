#!/bin/bash

wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

terraform -version

# Install tflint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Run TF LINTER
# tflint --init && tflint --recursive

# Install tfsec
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# RUN TFSEC
# tfsec .

# Install OPA
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
chmod +x opa && sudo mv opa /usr/local/bin/opa
          
# Install Conftest
CONTEST_VERSION=$(curl -s https://api.github.com/repos/open-policy-agent/conftest/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -L -o conftest.tar.gz "https://github.com/open-policy-agent/conftest/releases/download/${CONTEST_VERSION}/conftest_${CONTEST_VERSION#v}_Linux_x86_64.tar.gz"
tar xzf conftest.tar.gz
sudo mv conftest /usr/local/bin/conftest
conftest --version
opa version