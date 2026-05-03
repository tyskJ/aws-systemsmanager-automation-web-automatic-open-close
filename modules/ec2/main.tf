/************************************************************
KeyPair
************************************************************/
resource "tls_private_key" "ssh_keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "keypair_pem" {
  filename        = "${path.module}/../../envs/.key/keypair.pem"
  content         = tls_private_key.ssh_keygen.private_key_pem
  file_permission = "0600"
}

resource "aws_key_pair" "keypair" {
  key_name   = "common-keypair"
  public_key = tls_private_key.ssh_keygen.public_key_openssh
  tags = {
    Name = "common-keypair"
  }
}

/************************************************************
EC2
************************************************************/
resource "aws_instance" "this" {
  ami           = data.aws_ssm_parameter.amlinux_ami.value
  key_name      = aws_key_pair.keypair.id
  instance_type = "t3.large"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [
    var.sg_id
  ]
  ebs_optimized = true
  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
    encrypted             = true
    tags = {
      Name = "ec2-root-volume"
    }
  }
  metadata_options {
    http_tokens = "required"
  }
  maintenance_options {
    auto_recovery = "default"
  }
  disable_api_stop        = false
  disable_api_termination = false
  force_destroy           = true
  iam_instance_profile    = var.isntance_profile_name
  user_data_base64 = base64gzip(
    templatefile("${path.module}/userdata/linux_init.sh", {
      cwagent_conf = file("${path.module}/config/cwagent.json")
    })
  )
  tags = {
    Name = "ec2"
  }
  # userdataを変更すると再起動が走るため抑止
  # 代わりに、user_data_replace_on_change は効かなくなる
  lifecycle {
    ignore_changes = [
      user_data_base64
    ]
  }
}