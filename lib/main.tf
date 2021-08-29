data "aws_region" "default" {
}

resource "aws_lightsail_instance" "instance" {
  name              = var.name
  availability_zone = var.availability_zone
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  key_pair_name     = var.pubkey_name
  tags              = var.tags
  depends_on        = [aws_lightsail_key_pair.instance]
}

resource "aws_lightsail_static_ip_attachment" "instance" {
  count          = var.create_static_ip == true ? 1 : 0
  static_ip_name = aws_lightsail_static_ip.instance[count.index].id
  instance_name  = aws_lightsail_instance.instance.id
}

resource "aws_lightsail_static_ip" "instance" {
  count = var.create_static_ip == true ? 1 : 0
  name  = "${var.name}"
}

resource "aws_lightsail_key_pair" "instance" {
  count = var.pubkey_name == "" && var.use_default_key_pair == false ? 1 : 0
  name  = "${var.pubkey_name}"
  public_key = "${var.pubkey_value}"
}