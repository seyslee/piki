resource "aws_route53_zone" "terraform-training" {
  name = "terraform.training"
}

resource "aws_route53_record" "server1-record" {
  zone_id = aws_route53_zone.terraform-training.zone_id
  name    = "server1.terraform.training"
  type    = "A"
  ttl     = "300"
  records = ["104.236.247.8"]
}

resource "aws_route53_record" "www-record" {
  zone_id = aws_route53_zone.terraform-training.zone_id
  name    = "www.terraform.training"
  type    = "A"
  ttl     = "300"
  records = ["104.236.247.8"]
}

resource "aws_route53_record" "mail1-record" {
  zone_id = aws_route53_zone.terraform-training.zone_id
  name    = "terraform.training"
  type    = "MX"
  ttl     = "300"
  records = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 aspmx2.googlemail.com.",
    "10 aspmx3.googlemail.com.",
  ]
}
