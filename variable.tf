variable "default_region" {
    description = "default aws region"
    type = string
    default = "ap-south-1"
}
variable "dr_az" {
    description = "az for default region"
    type = list(string)
    default = [ "ap-south-1a","ap-south-1b","ap-south-1c" ]
}

variable "east_region" {
    description = "east reagion"
    type = string
    default = "us-east-1"
}
variable "east_az" {
    description = "az for east region"
    type = list(string)
    default = [ "us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f" ]
}

variable "west_region" {
    description = "west region"
    type = string
    default = "us-west-1"
}
variable "west_az" {
    description = "az for west region"
    type = list(string)
    default = [ "us-west-1a","us-west-1b","us-west-1c" ]
}

variable "cidr_block" {
    description = "cidr_block for VPC and Subnet"
    type = list(string)
    default = ["10.0.0.0/16", "10.1.0.0/16","10.0.1.0/24","10.0.2.0/24","10.1.1.0/24","10.1.2.0/24"]
}

variable "ingress_rule" {
    type = map(string)
    default = {
        "description" = "Allow HTTPS"
        "from_port"   = "443"
        "to_port"     = "443"
        "protocol"    = "tcp"
        "cidr_blocks" = "0.0.0.0/0"
    }
}
variable "egress_rule" {
    type = map(string)
    default = {
        "description" = "outbound traffic"
        "from_port"   = "0"
        "to_port"     = "0"
        "protocol"    = "-1"
        "cidr_blocks" = "0.0.0.0/0"
    }
}
