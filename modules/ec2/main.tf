resource "aws_instance" "webserver" {
  count = 2 

  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_ids[0]]
  subnet_id              = var.pub_subnet[0]
  key_name               = var.key_name
  associate_public_ip_address = true
  user_data_replace_on_change = true
  iam_instance_profile   = aws_iam_instance_profile.ec2_profiles[0].name  # Use the first IAM profile

  tags = {
    Name = "${var.resource_name}-webserver-${count.index + 1}"
    StartWithLambda = "true"
  }

  user_data = filebase64("${path.module}/user_data.sh")
}


resource "aws_iam_role" "ec2_roles" {
  for_each = { for idx, role in var.ec2_iam_roles : idx => role }

  name = each.value["role_name"]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = each.value["principal"]
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  for_each = { for idx, role in var.ec2_iam_roles : idx => role }

  name       = "${each.value["role_name"]}-Attachment"
  roles      = [aws_iam_role.ec2_roles[each.key].name]
  policy_arn = each.value["policy_arn"]
}

resource "aws_iam_instance_profile" "ec2_profiles" {
  for_each = { for idx, role in var.ec2_iam_roles : idx => role }

  name = "${each.value["role_name"]}-InstanceProfile"
  role = aws_iam_role.ec2_roles[each.key].name
}



















# resource "aws_iam_role" "ec2_role" {
#   name = "EC2FullAccessRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "ec2_policy_attach" {
#   name       = "EC2FullAccessAttachment"
#   roles      = [aws_iam_role.ec2_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }

# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "EC2InstanceProfile"
#   role = aws_iam_role.ec2_role.name
# }