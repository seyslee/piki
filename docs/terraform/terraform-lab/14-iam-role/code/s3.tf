# Note:
# You should change s3 bucket name `mybucket-seyslee...`
# to yours unique name before terraform init
resource "aws_s3_bucket" "b" {
  bucket        = "mybucket-seyslee-terraform-training"
  force_destroy = true

  tags = {
    Name      = "mybucket-seyslee-terraform-training"
    ManagedBy = "terraform"
  }
}
