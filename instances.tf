#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "jenkins"
  public_key = file("~/.ssh/id_rsa.pub")
}


#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "jenkins-master" {
  provider               = aws.region-master
  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.instance-type
  key_name               = aws_key_pair.master-key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  user_data              = file("userdata.sh")

  tags = {
    Name = "jenkins_master_tf"
  }
}
