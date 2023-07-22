terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_ec2_instance_types" "this" {
  filter {
    name   = "hypervisor"
    values = ["nitro"]
  }

  filter {
    name   = "processor-info.supported-architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "memory-info.size-in-mib"
    values = ["2048"]
  }

  filter {
    name   = "vcpu-info.default-vcpus"
    values = ["2"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "this" {
  for_each = toset(data.aws_ec2_instance_types.this.instance_types)

  ami           = data.aws_ami.ubuntu.id
  instance_type = each.key
}

resource "aws_spot_instance_request" "this" {
  for_each = toset(data.aws_ec2_instance_types.this.instance_types)

  ami           = data.aws_ami.ubuntu.id
  instance_type = each.key

  spot_type            = "one-time"
  wait_for_fulfillment = "true"
}
