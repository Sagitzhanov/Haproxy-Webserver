# Создание бакета
resource "aws_s3_bucket" "s-s-bucket" {
  bucket = "s3-s-s-bucket"

  tags = {
    Name = "My bucket"
  }
}


resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership" {
  bucket = aws_s3_bucket.s-s-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


# Приватный бакет
resource "aws_s3_bucket_acl" "my_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.my_bucket_ownership]
  bucket     = aws_s3_bucket.s-s-bucket.id
  acl        = "private"
}




# Загрузка объекта
resource "aws_s3_object" "object1" {
  bucket = aws_s3_bucket.s-s-bucket.id
  key    = "hosts.txt"
  acl    = "private"
  source = "hosts.txt"
  etag   = filemd5("hosts.txt")
}

resource "aws_s3_object" "object2" {
  bucket = aws_s3_bucket.s-s-bucket.id
  key    = "index.html.j2"
  acl    = "private"
  source = "index.html.j2"
  etag   = filemd5("index.html.j2")
}

resource "aws_s3_object" "object3" {
  bucket = aws_s3_bucket.s-s-bucket.id
  key    = "install.yml"
  acl    = "private"
  source = "install.yml"
  etag   = filemd5("install.yml")
}

resource "aws_s3_object" "object4" {
  bucket = aws_s3_bucket.s-s-bucket.id
  key    = "haproxy.cfg"
  acl    = "private"
  source = "haproxy.cfg"
  etag   = filemd5("haproxy.cfg")
}

resource "aws_s3_object" "object5" {
  bucket = aws_s3_bucket.s-s-bucket.id
  key    = "frankfurt.pem"
  acl    = "private"
  source = "frankfurt.pem"
  etag   = filemd5("frankfurt.pem")
}
