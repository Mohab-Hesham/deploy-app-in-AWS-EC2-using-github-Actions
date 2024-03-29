
resource "aws_key_pair" "deployer_key" {
  key_name   = "ec2-deployer-key"
  public_key = file("${path.module}/ec2-deployer-key.pub")
}

resource "aws_instance" "app_instance" {
  ami           = "ami-0c02fb55956c7d316"  # Use an appropriate AMI for your region
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key.key_name

  tags = {
    Name = "MyAppInstance"
  }

  # Outputs to fetch the instance IP after creation
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > instance_ip.txt"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}
