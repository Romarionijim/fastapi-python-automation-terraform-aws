output "vpc_id" {
  value = aws_vpc.staging-vpc.id
}

output "subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
}
