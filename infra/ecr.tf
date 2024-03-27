resource "aws_ecr_repository" "ecr" {
  name                      = var.ecr_repo_name
  image_tag_mutability      = "MUTABLE"
  image_scanning_configuration {
    scan_on_push            = true
  }
    lifecycle {
      ignore_changes=[
      name
      ]
  }
}

