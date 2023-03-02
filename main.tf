terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

resource "aws_instance" "app_server" {
  count         = 1
  ami           = var.amis["us-west-2"]
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "InstanciaDeExemplo${count.index}"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"] //link de security group na instancia, com id do group
}

resource "aws_instance" "dev4" {
  ami           = var.amis["us-west-2"]
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "dev4"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"] //link de security group na instancia, com id do group
  depends_on = [
    aws_s3_bucket.dev4
  ]
}

resource "aws_instance" "dev5" {
  ami           = var.amis["us-west-2"]
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "dev5"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"] //link de security group na instancia, com id do group
}

resource "aws_instance" "dev6" {
  provider      = aws.us-east-2
  ami           = var.amis["us-east-2"]
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "dev6"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh-us-east.id}"] //link de security group na instancia, com id do group
  depends_on = [
    aws_dynamodb_table.dynamodb-homolog
  ]
}

resource "aws_instance" "dev7" {
  provider      = aws.us-east-2
  ami           = var.amis["us-east-2"]
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "dev7"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh-us-east.id}"] //link de security group na instancia, com id do group
}

resource "aws_s3_bucket" "dev4" {
  bucket = "terraform-curso-dev4"

  tags = {
    Name = "terraform-curso-dev4"
  }
}

resource "aws_s3_bucket" "lab-homologacao" {
  bucket = "terraform-homologacao"

  tags = {
    Name = "terraform-homologacao"
  }
}


resource "aws_dynamodb_table" "dynamodb-homolog" {
  provider     = aws.us-east-2
  name         = "GameScores"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  range_key    = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }
}
