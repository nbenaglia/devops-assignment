resource "aws_codestarconnections_connection" "github" {
  name          = "github-connection"
  provider_type = "GitHub"
}
resource "aws_s3_bucket" "cicd" {
  bucket = "cicd-ajd783nc83ng94"
}

resource "aws_s3_bucket_acl" "cicd" {
  bucket = aws_s3_bucket.cicd.id
  acl    = "private"
}

resource "aws_iam_role" "cicd" {
  name = "cicd"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cicd" {
  role = aws_iam_role.cicd.name
  name = "codebuild"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
     {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:Describe*",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart",
        "ecr:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.cicd.arn}",
        "${aws_s3_bucket.cicd.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "codestar-connections:UseConnection",
      "Resource": "${aws_codestarconnections_connection.github.arn}"
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "cicd" {
  name          = "cicd-project"
  description   = "My CICD project with CodeBuild"
  build_timeout = "5"
  service_role  = aws_iam_role.cicd.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.cicd.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "jsapp"
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "1.0"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "cicd"
      stream_name = "cicd-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.cicd.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/nbenaglia/react-image-compressor.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

  tags = {
    Environment = "cicd"
  }
}
