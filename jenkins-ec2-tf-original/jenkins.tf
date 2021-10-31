provider "aws" {
  region = var.region
}
resource "aws_security_group" "JenkinsSG" {
  name = "Jenkins SG"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ssm_parameter" "linuxAmi" {
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


resource "aws_key_pair" "master-key" {
  key_name   = "jenkins"
  public_key = file("~/.ssh/id_rsa.pub")
}
#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "JenkinsEC2" {
  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.instance_type
  key_name               = aws_key_pair.master-key.key_name
  vpc_security_group_ids = [aws_security_group.JenkinsSG.id]
  user_data              = file("userdata.sh")
  tags = {
    Name = "jenkins_master_tf"
  }
}
output "jenkins_endpoint" {
  value = formatlist("http://%s:%s/", aws_instance.JenkinsEC2.*.public_ip, "8080")
}
