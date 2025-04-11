#!/bin/bash

source './params.sh'
source './utils.sh'

# This will update the lambda function
update_lambda_code() {
  function_name=$1
  bucket_key=$2

  echo "Updating $function_name lambda function..."

  aws lambda update-function-code \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION" \
    --function-name "$function_name" \
    --s3-bucket "$RESOURCE_BUCKET_NAME" \
    --s3-key "$bucket_key" > $NULL_DEVICE 2>&1 || error_and_exit "Error while updating the $function_name function..."

  echo_success "Successfully updated $function_name function."
}