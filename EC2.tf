provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "wordpress" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "Wordpress"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd php php-mysqlnd php-gd
              systemctl start httpd
              systemctl enable httpd
              yum install -y mysql
              systemctl start mysqld
              systemctl enable mysqld
              echo "CREATE DATABASE wordpress;" | mysql
              echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'your_password';" | mysql
              echo "FLUSH PRIVILEGES;" | mysql
              EOF
}
