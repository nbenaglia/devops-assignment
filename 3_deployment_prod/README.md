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









6. Destroy all resources with `terraform destroy`

7. Bye bye
