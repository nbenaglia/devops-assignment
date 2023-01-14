# Deployment in production

Steps:

1. Install terraform locally

2. Have a valid AWS credentials or token, verify with command:
  `aws sts get-caller-identity`

   You should get back a JSON rensponse like this:

  ```{
    "Account": "SOMENUMBERS",
    "UserId": "SOMENUMBERSANDLETTERS",
    "Arn": "arn:aws:iam::SOMENUMBERS:user/nicobenaz"
  }```

3. Go into `terraform` folder and type `terraform init`  and `terraform plan/apply`

4. Go to your AWS console into Codebuild section and enjoy it.

5. Destroy all resources with `terraform destroy`

6. Bye bye
