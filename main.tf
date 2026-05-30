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
    cidr_block = var.cidr_block[2]
    vpc_id = aws_vpc.vpc_main.id
    availability_zone = var.east_az[0]
    map_public_ip_on_launch = true
}
resource "aws_subnet" "main_pri_sub" {
    cidr_block = var.cidr_block[3]
    vpc_id = aws_vpc.vpc_main.id
    availability_zone = var.east_az[1]
}
resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.vpc_main.id
}

resource "aws_vpc" "vpc_bkp" {
    cidr_block = var.cidr_block[1]
    provider = aws.west
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
}
resource "aws_subnet" "bkp_pub_sub" {
    cidr_block = var.cidr_block[4]
    vpc_id = aws_vpc.vpc_bkp.id
    availability_zone = var.west_az[0]
    map_public_ip_on_launch = true
}
resource "aws_subnet" "bkp_pri_sub" {
    cidr_block = var.cidr_block[5]
    vpc_id = aws_vpc.vpc_bkp.id
    availability_zone = var.west_az[1]
}
resource "aws_internet_gateway" "bkp_igw" {
    vpc_id = aws_vpc.vpc_bkp.id
}
