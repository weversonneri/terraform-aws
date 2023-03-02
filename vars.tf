variable "amis" {
  type = map(string)

  default = {
    "us-west-2" = "ami-0735c191cf914754d"
    "us-east-2" = "ami-0cc87e5027adcdca8"
  }
}

variable "cdirs_acesso_remoto" {
  description = "uma lista de ips para uso na VPC"
  type        = list(string)

  default = ["ipdamaquina/32", "ipdamaquina/32"]
}

variable "key_name" {
  default = "terraform-aws"
}

variable "instance_type" {
  type = string

  default = "t2.micro"
}
