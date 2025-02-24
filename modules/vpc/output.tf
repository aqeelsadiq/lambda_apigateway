output "vpc_ids" {
  value = { for k, v in aws_vpc.this : k => v.id }
}

output "public_subnet_ids" {
  value = { for k, v in aws_subnet.public : k => v.id }
}

output "private_subnet_ids" {
  value = { for k, v in aws_subnet.private : k => v.id }
}

output "internet_gateway_ids" {
  value = { for k, v in aws_internet_gateway.this : k => v.id }
}

output "nat_gateway_ids" {
  value = { for k, v in aws_nat_gateway.this : k => v.id }
}










# output "vpc_id" {
#   value = { for k, v in aws_vpc.main : k => v.id }
# }

# output "pub_subnet" {
#   value = { for k, v in aws_subnet.public : k => v.id }
# }

# output "pri_subnet" {
#   value = { for k, v in aws_subnet.private : k => v.id }
# }

# output "igw_id" {
#   value = { for k, v in aws_internet_gateway.igw : k => v.id }
# }
