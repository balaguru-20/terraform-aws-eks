resource "aws_instance" "this" {
  ami                    = "ami-09c813fb71547fc4f"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  instance_type          = "t3.micro"
  subnet_id              = local.public_subnet_id

  #20gb is not enough
  root_block_device {
    volume_size = 50    #Set root volume size to 50gb
    volume_type = "gp3" # Use gp3 for better performance (optional)
  }
  user_data = file("bastion.sh")
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}