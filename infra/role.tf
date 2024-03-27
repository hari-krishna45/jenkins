## used to create ecstaskexecution role and assign requried permissions
data "template_file" "role_policy" {
  template = file("./jsontemplates/ecsTaskexecutionrole.json.tpl")
}
data "template_file" "policy" {
  template = file("./jsontemplates/ecspolicy.json")
}
resource "aws_iam_role" "role" {
   name                = var.role_name
   assume_role_policy  = data.template_file.role_policy.rendered
}

resource "aws_iam_policy" "policy" {
  name          = var.policy_name
  description   = "A Flex Policy"
  policy        = data.template_file.policy.rendered
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role          = aws_iam_role.role.name
  policy_arn    = aws_iam_policy.policy.arn
}

resource "aws_iam_user" "iam_user" {
  force_destroy = true
  name          = "${var.role_name}_user"
}

resource "aws_iam_user_policy_attachment" "plocy_attachment" {
  user       = aws_iam_user.iam_user.name
  policy_arn = aws_iam_policy.policy.arn
}
resource "aws_iam_access_key" "jenkins" {
  user = aws_iam_user.iam_user.name
}
