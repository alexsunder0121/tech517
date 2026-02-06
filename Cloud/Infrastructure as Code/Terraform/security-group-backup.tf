# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security group (no inline rules)
resource "aws_security_group" "tech517_alex_tf_allow_22_3000_80" {
  name        = "tech517-alex-tf-allow-port-22-3000-80"
  description = "Allow SSH from my IP, allow 3000 and 80 from all"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "tech517-alex-tf-allow-port-22-3000-80"
  }
}

# Ingress: SSH from your IP only
resource "aws_vpc_security_group_ingress_rule" "ssh_from_my_ip" {
  security_group_id = aws_security_group.tech517_alex_tf_allow_22_3000_80.id
  cidr_ipv4         = "77.103.28.163/32"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# Ingress: Port 3000 from all
resource "aws_vpc_security_group_ingress_rule" "port_3000_from_all" {
  security_group_id = aws_security_group.tech517_alex_tf_allow_22_3000_80.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 3000
  to_port           = 3000
}

# Ingress: Port 80 from all
resource "aws_vpc_security_group_ingress_rule" "http_from_all" {
  security_group_id = aws_security_group.tech517_alex_tf_allow_22_3000_80.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# Egress: Allow all outbound
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.tech517_alex_tf_allow_22_3000_80.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

