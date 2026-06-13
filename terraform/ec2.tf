data "aws_ami" "ubuntu_24_04" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu_24_04.id
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_profile.name

  user_data = file("${path.module}/userdata/jenkins.sh")

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.ubuntu_24_04.id
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]

  user_data = file("${path.module}/userdata/sonarqube.sh")

  tags = {
    Name = "sonarqube-server"
  }
}
