

source './utils.sh'
source './user-management.sh'

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
    --s3-key "$bucket_key" || error_and_exit "Error while updating the $function_name function..."

  echo_success "Successfully updated $function_name function."
}
build_backend_auth_zip
upload_build_project_to_s3
update_lambda_code "AuthLambda" "$S3_LAMBDA_COMMON_PATH/backend-auth/build_backend_auth.zip"