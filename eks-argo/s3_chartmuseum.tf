resource "aws_s3_bucket" "chartmuseum" {
  bucket = format("%s-%s-chartmuseum", var.project_name, data.aws_caller_identity.current.account_id)

  tags = merge(
    {
      Name = format("%s-%s-chartmuseum", var.project_name, data.aws_caller_identity.current.account_id)
    },
    var.common_tags
  )
}

resource "aws_s3_bucket_ownership_controls" "chartmuseum" {
  bucket = aws_s3_bucket.chartmuseum.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "chartmuseum" {
  bucket = aws_s3_bucket.chartmuseum.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.chartmuseum
  ]
}
