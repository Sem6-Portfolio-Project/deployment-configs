#!/bin/bash

export CUR_DIR=$(pwd)

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  export NULL_DEVICE="NUL"
else
  export NULL_DEVICE="/dev/null"
fi

#This will give project root. (/../..) change accordingly based on the project setup
export PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd) /../.."

#Project directories
export AUTH_BACKEND="$PROJECT_ROOT/mobile-app-backend-auth"
export BUS_MANAGE_BACKEND="$PROJECT_ROOT/bus-tracking-and-scheduling"
export LAYERS_DIR="$PROJECT_ROOT/layers"

#Template directories
export TEMPLATE_DIR="$PROJECT_ROOT/deployment-configs/cf-templates"

#Credintials
export AWS_PROFILE=personal
region=$(aws configure get region --profile "$AWS_PROFILE")
export AWS_REGION=$region
export AWS_REGION='ap-south-1'
export S3_DOMAIN_URL="https://s3.$AWS_REGION.amazonaws.com"
#export RESOURCE_BUCKET_NAME="481665090781-mobile-app-resources"
export RESOURCE_BUCKET_NAME="481665090781-mobile-app-resources-ap"
export S3_LAMBDA_COMMON_PATH="source-code/lambdas"
export S3_TEMPLATES_COMMON_PATH="deployment-configs/templates"
export S3_LAYERS_COMMON_PATH="layers"

#params
export ConsoleUrl="www.google.com"
export Stage="dev"


