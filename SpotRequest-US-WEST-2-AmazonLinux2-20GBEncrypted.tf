resource "aws_launch_template" "AmazonLinux2-Spot" {
  name = "AmazonLinux2-LaunchTemplate(20GBEncryptedVolume)"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type = "gp2"
      volume_size = "20"
      encrypted   = "true"
      kms_key_id  = "arn:aws:kms:us-west-2:454376113268:key/af420058-3c2c-4f23-9122-41de960009b6"
    }
  }
  credit_specification {
    cpu_credits = "standard"
  }
  disable_api_termination = "false"
  ebs_optimized           = true
  iam_instance_profile {
    arn = "arn:aws:iam::454376113268:instance-profile/EC2-Administrator"
  }
  image_id                             = "ami-0d6621c01e8c2de2c"
  instance_initiated_shutdown_behavior = "stop"
  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }
  instance_type = "t3.medium"
  key_name      = "Jason's Keypair"
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  monitoring {
    enabled = "false"
  }
  network_interfaces {
    associate_public_ip_address = "true"
    delete_on_termination       = "true"
    description                 = "eth0"
    device_index                = 0
  }
  placement {
    tenancy = "default"
  }
  vpc_security_group_ids = ["sg-0838667103304452f"]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "My Linux Spot VM"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "My Linux Spot VM"
    }
  }
  user_data = filebase64("${path.module}/AmazonLinux2-Spot-userdata.sh")
}

resource "aws_ec2_fleet" "AmazonLinux2-Spot" {
  launch_template_config {
    launch_template_specification {
      version            = aws_launch_template.AmazonLinux2-Spot.latest_version
      launch_template_id = aws_launch_template.AmazonLinux2-Spot.id
    }
  }
  spot_options {
    allocation_strategy            = "lowestPrice"
    instance_interruption_behavior = "stop"
  }
  target_capacity_specification {
    default_target_capacity_type = "spot"
    total_target_capacity        = "1"
  }
}
