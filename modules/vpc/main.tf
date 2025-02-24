resource "aws_vpc" "this" {
  for_each = var.vpcs

  cidr_block         = each.value.cidr
  enable_dns_support = true

  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "public" {
  for_each = { for subnet in var.pub_subnets : "${subnet.vpc_name}-${subnet.name}" => subnet }

  vpc_id                  = aws_vpc.this[each.value.vpc_name].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = each.value.vpc_name
  }
}

resource "aws_subnet" "private" {
  for_each = { for subnet in var.pri_subnets : "${subnet.vpc_name}-${subnet.name}" => subnet }

  vpc_id                  = aws_vpc.this[each.value.vpc_name].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = each.value.vpc_name
  }
}

resource "aws_internet_gateway" "this" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  tags = {
    Name = "${each.key}-IGW"
  }
}

resource "aws_eip" "nat" {
  for_each = aws_vpc.this

  domain = "vpc"

  tags = {
    Name = "${each.key}-NAT-EIP"
  }
}

resource "aws_nat_gateway" "this" {
  for_each = aws_vpc.this

  allocation_id = aws_eip.nat[each.key].id

  subnet_id = tolist([for k, v in aws_subnet.public : v.id if v.vpc_id == each.value.id])[0]

  connectivity_type = "public"

  tags = {
    Name = "${each.key}-NAT-Gateway"
  }
}

resource "aws_route_table" "public" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[each.key].id
  }

  tags = {
    Name = "${each.key}-Public-RT"
  }
}

resource "aws_route_table" "private" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = {
    Name = "${each.key}-Private-RT"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.value.tags["Name"]].id 
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.value.tags["Name"]].id
}


















































# resource "aws_vpc" "main-vpc" {
#   cidr_block         = var.vpc_cidr
#   instance_tenancy   = "default"
#   enable_dns_support = true

#   tags = {
#     Name = "${var.resource_name}-VPC"
#   }
# }

# resource "aws_subnet" "pub-subnet1" {
#   vpc_id                  = aws_vpc.main-vpc.id
#   count                   = length(var.pub_subnet)
#   cidr_block              = var.pub_subnet[count.index]["cidr_block"]
#   availability_zone       = var.pub_subnet[count.index]["availability_zone"]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = var.pub_subnet[count.index]["name"]
#   }
# }


# resource "aws_subnet" "pri-subnet1" {
#   vpc_id     = aws_vpc.main-vpc.id
#   count      = length(var.pri_subnet)
#   cidr_block = var.pri_subnet[count.index]["cidr_block"]

#   availability_zone       = var.pri_subnet[count.index]["availability_zone"]
#   map_public_ip_on_launch = false

#   tags = {
#     Name = var.pri_subnet[count.index]["name"]
#   }
# }


# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main-vpc.id

#   tags = {
#     Name = "${var.resource_name}-igw"
#   }
# }

# resource "aws_eip" "nat-eip" {
#   domain = "vpc"

#   tags = {
#     Name = "${var.resource_name}nat-eip"
#   }
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id     = aws_eip.nat-eip.id
#   subnet_id         = aws_subnet.pub-subnet1[0].id
#   connectivity_type = "public"
#   tags = {
#     Name = "${var.resource_name}nat-gateway"
#   }
# }

# resource "aws_route_table" "pub-route-table" {
#   vpc_id = aws_vpc.main-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "${var.resource_name}-pub-route-table"
#   }
# }

# resource "aws_route_table" "pri-route-table" {
#   vpc_id = aws_vpc.main-vpc.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gateway.id
#   }

#   tags = {
#     Name = "${var.resource_name}-pri-route-table"
#   }
# }

# resource "aws_route_table_association" "pub-sn1-rt-assoc" {
#   count          = length(var.pub_subnet)
#   subnet_id      = aws_subnet.pub-subnet1[count.index].id
#   route_table_id = aws_route_table.pub-route-table.id
# }

# resource "aws_route_table_association" "pub-sn2-rt-assoc" {
#   count          = length(var.pri_subnet)
#   subnet_id      = aws_subnet.pri-subnet1[count.index].id
#   route_table_id = aws_route_table.pri-route-table.id
# }
