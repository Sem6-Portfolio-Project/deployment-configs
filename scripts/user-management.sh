#!/bin/bash

source './params.sh'
source './utils.sh'
source './update-lambda.sh'

# This is distribution destination
DIST_AUTH="$AUTH_BACKEND/dist"

ZIP_FILE_NAME_AUTH_BACKEND='build_backend_auth'
S3_DIR_LAMBDA_CODE_FOR_AUTH="$S3_LAMBDA_COMMON_PATH/backend-auth"
TEMPLATE_NAME_FOR_AUTH="user-management.yaml"

build_and_upload_auth_backend_code() {
  echo "Building the auth backend code..."
  # Build the auth backend and create the zip folder
  build_backend_and_create_zip "$DIST_AUTH" "$AUTH_BACKEND" "$ZIP_FILE_NAME_AUTH_BACKEND"

  echo "uploading the auth backend code..."
  # Upload build zip file to the S3 bucket.
  upload_build_project_to_s3 "$DIST_AUTH" "$ZIP_FILE_NAME_AUTH_BACKEND" "$S3_DIR_LAMBDA_CODE_FOR_AUTH"
}

upload_and_validate_auth_cf_template() {
  echo "Uploading the auth cf template..."
  # Upload the CF template to the s3 bucket
  upload_cf_template "$TEMPLATE_DIR" "$TEMPLATE_NAME_FOR_AUTH" "$S3_TEMPLATES_COMMON_PATH"

  echo "Validating the auth cf template..."
  # validating the cf template
  validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/$TEMPLATE_NAME_FOR_AUTH"
}

update_auth_lambda() {
  build_and_upload_auth_backend_code
  update_lambda_code "AuthLambda" "$S3_DIR_LAMBDA_CODE_FOR_AUTH/$ZIP_FILE_NAME_AUTH_BACKEND.zip"
}

