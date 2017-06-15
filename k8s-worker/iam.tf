# Set up IAM Instance Profile for Kubernetes worker
#

resource "aws_iam_instance_profile" "k8s-worker" {
    name = "${var.name}-worker"
    role = "${aws_iam_role.k8s-worker.name}"
}

resource "aws_iam_role" "k8s-worker" {
    name = "${var.name}-worker"
    path = "/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "k8s-worker" {
    name = "${var.name}-worker"
    role = "${aws_iam_role.k8s-worker.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
