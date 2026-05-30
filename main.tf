provider "aws" {
    region = var.default_region
}
provider "aws" {
    alias = "east"
    region = var.east_region
}

provider "aws" {
    alias = "west"
    region = var.west_region
}

resource "aws_vpc" "vpc_main" {
    cidr_block = var.cidr_block[0]
    provider = aws.east
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
}
resource "aws_subnet" "main_pub_sub" {
    provider = aws.east
    cidr_block = var.cidr_block[2]
    vpc_id = aws_vpc.vpc_main.id
    availability_zone = var.east_az[0]
    map_public_ip_on_launch = true
}
resource "aws_subnet" "main_pri_sub" {
    provider = aws.east
    cidr_block = var.cidr_block[3]
    vpc_id = aws_vpc.vpc_main.id
    availability_zone = var.east_az[1]
}
resource "aws_internet_gateway" "main_igw" {
    provider = aws.east
    vpc_id = aws_vpc.vpc_main.id
}
resource "aws_route_table" "main_route_table" {
    provider = aws.east
    vpc_id = aws_vpc.vpc_main.id
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_igw.id
    }
}
resource "aws_route_table_association" "main_route_asso" {
    provider = aws.east
    subnet_id = aws_subnet.main_pub_sub.id
    route_table_id = aws_route_table.main_route_table.id
}
resource "aws_security_group" "east_sg" {
    provider = aws.east
    vpc_id = aws_vpc.vpc_main.id
    ingress = {
        description = var.ingress_rule.description
        from_port = var.ingress_rule.from_port
        to_port = var.ingress_rule.to_port
        protocol = var.ingress_rule.protocol
        cidr_blocks = var.ingress_rule.cidr_blocks
    }
    egress = {
        description = var.egress_rule.description
        from_port = var.egress_rule.from_port
        to_port = var.egress_rule.to_port
        protocol = var.egress_rule.protocol
        cidr_blocks = var.egress_rule.cidr_blocks
    }
}
resource "aws_security_group" "east_db_sg" {
    provider = aws.east
    vpc_id = aws_vpc.vpc_main.id
    ingress = {
        description = "db from app"
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        aws_security_group = [aws_security_group.east_sg.id]
    }
    egress = {
        description = "isolate"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = aws_vpc.vpc_main.cidr_block
    }
}

resource "aws_vpc" "vpc_bkp" {
    cidr_block = var.cidr_block[1]
    provider = aws.west
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
}
resource "aws_subnet" "bkp_pub_sub" {
    provider = aws.west
    cidr_block = var.cidr_block[4]
    vpc_id = aws_vpc.vpc_bkp.id
    availability_zone = var.west_az[0]
    map_public_ip_on_launch = true
}
resource "aws_subnet" "bkp_pri_sub" {
    provider = aws.west
    cidr_block = var.cidr_block[5]
    vpc_id = aws_vpc.vpc_bkp.id
    availability_zone = var.west_az[1]
}
resource "aws_internet_gateway" "bkp_igw" {
    provider = aws.west
    vpc_id = aws_vpc.vpc_bkp.id
}
resource "aws_route_table" "bkp_route_table" {
    provider = aws.west
    vpc_id = aws_vpc.vpc_bkp.id
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.bkp_igw.id
    }
}
resource "aws_route_table_association" "bkp_route_asso" {
    provider = aws.west
    subnet_id = aws_subnet.bkp_pub_sub.id
    route_table_id = aws_route_table.bkp_route_table.id
}
resource "aws_security_group" "east_sg" {
    provider = aws.west
    vpc_id = aws_vpc.vpc_bkp.id
    ingress = {
        description = var.ingress_rule.description
        from_port = var.ingress_rule.from_port
        to_port = var.ingress_rule.to_port
        protocol = var.ingress_rule.protocol
        cidr_blocks = var.ingress_rule.cidr_blocks
    }
    egress = {
        description = var.egress_rule.description
        from_port = var.egress_rule.from_port
        to_port = var.egress_rule.to_port
        protocol = var.egress_rule.protocol
        cidr_blocks = var.egress_rule.cidr_blocks
    }
}
resource "aws_security_group" "wesr_db_sg" {
    provider = aws.west
    vpc_id = aws_vpc.vpc_bkp.id
    ingress = {
        description = "db from app"
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        aws_security_group = [aws_security_group.west_sg.id]
    }
    egress = {
        description = "isolate"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = aws_vpc.vpc_bkp.cidr_block
    }
}
