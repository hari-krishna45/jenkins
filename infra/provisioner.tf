data "aws_caller_identity" "current" {}
locals {
    account_id = data.aws_caller_identity.current.account_id
}
resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = <<-EOT
       chmod +x dockerinstall.sh && ./dockerinstall.sh && \
       sudo docker build -t ${aws_ecr_repository.ecr.repository_url}:${var.image_version} --build-arg="PEM_KEY=${var.keyname}" ../ && \
       aws ecr get-login-password --region ${var.region} | sudo docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com && \
      sudo docker push ${aws_ecr_repository.ecr.repository_url}:${var.image_version}
    EOT
  }
  depends_on = [aws_ecr_repository.ecr, aws_key_pair.keypair]
}
