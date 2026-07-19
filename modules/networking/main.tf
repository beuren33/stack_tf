resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.project_name}-vpc"
        Enviroment = var.environment
    
    }
}
resource "aws_subnet" "public"{
    count = length(var.public_subnets_cidrs)

    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags ={
        Name = "${var.project_name}-public-${var.availability_zones[count.index]}"
        Enviroment = var.environment
    }
}
resource "aws_subnet" "private_app"{
    count = length(var.private_app_subnets_cidrs)

    vpc_id = aws_vpc.main.id
    cidr_block = var.private_app_subnets_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.project_name}-private-app-${var.availability_zones[count.index]}"
        Enviroment = var.environment
    }
}
resource "aws_subnet" "private_db"{
    count = length(var.private_db_subnets_cidrs)

    vpc_id = aws_vpc.main.id
    cidr_block = var.private_db_subnets_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.project_name}-private-db-${var.availability_zones[count.index]}"
        Enviroment = var.environment
    }
}
resource "aws_internet_gateway" "gateway_internet"{
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-internet-gateway"
    }
}
resource "aws_eip" "main"{
    domain = "vpc"

    tags = {
        Name = "${var.project_name}-elastic-ip"
    }
}
resource "aws_nat_gateway" "nat"{
    allocation_id = aws_eip.main.id
    subnet_id = aws_subnet.public[0].id
    depends_on = [ aws_internet_gateway.gateway_internet ]

    tags = {
        Name = "${var.project_name}-nat-gateway"
    }

}
resource "aws_route_table" "public"{
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway_internet.id
    }
}
resource "aws_route_table" "private"{
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
}
resource "aws_route_table_association" "public"{
    count = length(aws_subnet.public)

    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app"{
    count = length(aws_subnet.private_app)

    subnet_id = aws_subnet.private_app[count.index].id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db"{
    count = length(aws_subnet.private_db)

    subnet_id = aws_subnet.private_db[count.index].id
    route_table_id = aws_route_table.private.id
}