resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.bucket_name
}


resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObjectAcl"
        ]
        Resource = [
          "${aws_s3_bucket.frontend_bucket.arn}/*",
          "${aws_s3_bucket.frontend_bucket.arn}"
        ]
      }
    ]
  })
}

module "website_with_cname" {
  source = "./s3-custom"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  namespace      = "eg"
  stage          = "prod"
  name           = "voinc-fe-auto"
  hostname       = "voinc.click"
  parent_zone_id = "Z05845681PX6ZVL59KV9T"
}