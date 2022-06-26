resource "aws_launch_configuration" "example-launchconfig" {
  name_prefix                 = "example-launchconfig"
  image_id                    = var.AMIS[var.AWS_REGION]
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.mykeypair.key_name
  security_groups             = [aws_security_group.allow-ssh.id]

  # Associate a public ip address with an instance in a VPC
  # Default: false
  associate_public_ip_address = true
}

resource "aws_autoscaling_group" "example-autoscaling" {
  name                      = "example-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration      = aws_launch_configuration.example-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}
