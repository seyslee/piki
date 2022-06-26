terraform {
  backend "s3" {
    # Note:
    # You must change bucket name to yours.
    # Amazon S3 supports global buckets, 
    # which means that each bucket name must
    # be "UNIQUE" across all AWS accounts in
    # all the AWS Regions within a partition.
    bucket = "terraform-tfstate-seyslee"
    key    = "terraform/demo3"
  }
}
