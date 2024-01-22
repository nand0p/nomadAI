resource "aws_vpc" "nomad_ai" {
  count      = var.nomad_ai_vpc_id == "" ? 1 : 0
  cidr_block = var.nomad_ai_vpc_cidr
  tags       = local.tags
}

resource "aws_subnet" "nomad_ai" {
  count             = var.nomad_ai_subnet_id == "" ? 1 : 0
  vpc_id            = aws_vpc.nomad_ai[0].id
  cidr_block        = var.nomad_ai_subnet_cidr
  tags              = local.tags
}

resource "aws_internet_gateway" "nomad_ai" {
  count  = var.nomad_ai_vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.nomad_ai[0].id
  tags   = local.tags
}

resource "aws_route_table" "nomad_ai" {
  count  = var.nomad_ai_vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.nomad_ai[0].id
  tags   = local.tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nomad_ai[0].id
  }
}

resource "aws_route_table_association" "nomad_ai" {
  count          = var.nomad_ai_subnet_id == "" ? 1 : 0
  subnet_id      = local.subnet_id
  route_table_id = aws_route_table.nomad_ai[0].id
}
