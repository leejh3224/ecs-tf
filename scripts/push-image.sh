#!/bin/bash

# exit when any command fails
set -e

AWS_REGION=$(terraform output -raw aws_region)
AWS_ECR_URL=$(terraform output -raw aws_ecr_url)
AWS_ECR_REPOSITORY_URL=$(terraform output -raw aws_ecr_repository_url)
AWS_PROFILE=$(terraform output -raw aws_profile)

aws ecr get-login-password --region $AWS_REGION --profile $AWS_PROFILE | docker login --username AWS --password-stdin $AWS_ECR_URL

docker build -t $AWS_ECR_REPOSITORY_URL .
docker push $AWS_ECR_REPOSITORY_URL
