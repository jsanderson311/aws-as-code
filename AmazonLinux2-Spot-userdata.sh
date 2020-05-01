#!/bin/bash
yum update -y
yum install -y git
sudo yum install -y python3 python3-pip python3-wheel python3-setuptools python3-libs
python3 -m pip install --user --upgrade pip >> userdata.log
wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip >> userdata.log
unzip ./terraform_0.12.24_linux_amd64.zip >> userdata.log
sudo mv terraform /usr/local/bin/ && rm terraform_0.12.24_linux_amd64.zip
terraform --version >> userdata.log
python --version >> userdata.log
