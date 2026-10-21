
resource "aws_security_group" "app" {
  name        = "${var.name}-app-sg"
  description = "Security group for application workloads"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-app-sg"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "app" {
  for_each = {
    for item in flatten([
      for index, rule in var.egress_rules : [
        for cidr in rule.cidr_blocks : {
          key         = "${index}-${cidr}"
          description = rule.description
          from_port   = rule.from_port
          to_port     = rule.to_port
          protocol    = rule.protocol
          cidr        = cidr
        }
      ]
    ]) : item.key => item
  }

  security_group_id = aws_security_group.app.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr
}
