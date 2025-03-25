#!/bin/bash

set -e

export CUR_DIR=$(pwd)

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  NULL_DEVICE="NUL"
else
  NULL_DEVICE="/dev/null"
fi

#This will give project root. (/../..) change accordingly based on the project setup
export PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd) /../.."

#Project directories
export AUTH_BACKEND="$PROJECT_ROOT/mobile-app-backend-auth"


#Credintials
export AWS_PROFILE=personal
export RESOURCE_BUCKET_NAME="481665090781-mobile-app-resources"
export S3_LAMBDA_COMMON_PATH="source-code/lambdas"