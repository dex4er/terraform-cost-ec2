data "aws_ec2_instance_types" "this" {
  filter {
    name   = "hypervisor"
    values = ["nitro"]
  }

  filter {
    name   = "processor-info.supported-architecture"
    values = [var.arch]
  }

  filter {
    name   = "memory-info.size-in-mib"
    values = [var.memory * 1024]
  }

  filter {
    name   = "vcpu-info.default-vcpus"
    values = [var.vcpus]
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

  depends_on = [null_resource.break]
}

resource "aws_spot_instance_request" "this" {
  for_each = toset(data.aws_ec2_instance_types.this.instance_types)

  ami           = data.aws_ami.ubuntu.id
  instance_type = each.key

  spot_type            = "one-time"
  wait_for_fulfillment = "true"

  depends_on = [null_resource.break]
}

resource "null_resource" "break" {
  provisioner "local-exec" {
    ## It must fail to prevent creating EC2 instances
    command = "false"
  }
}

output "instance_types" {
  value = sort(data.aws_ec2_instance_types.this.instance_types)
}
