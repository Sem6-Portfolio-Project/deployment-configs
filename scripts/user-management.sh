#!/bin/bash

source './params.sh'
source './utils.sh'

# This is distribution destination
DIST="$AUTH_BACKEND/dist"

ZIP_FILE_NAME_BACKEND='build_backend_auth'
S3_DIR_LAMBDA_CODE="$S3_LAMBDA_COMMON_PATH/backend-auth"
TEMPLATE_NAME="user-management.yaml"

build_and_upload_auth_backend_code() {
  echo "Building the auth backend code..."
  # Build the auth backend and create the zip folder
  build_backend_and_create_zip "$DIST" "$AUTH_BACKEND" "$ZIP_FILE_NAME_BACKEND"

  echo "uploading the auth backend code..."
  # Upload build zip file to the S3 bucket.
  upload_build_project_to_s3 "$DIST" "$ZIP_FILE_NAME_BACKEND.zip" "$S3_DIR_LAMBDA_CODE"
}

upload_and_validate_auth_cf_template() {
  echo "Uploading the auth cf template..."
  # Upload the CF template to the s3 bucket
  upload_cf_template "$TEMPLATE_DIR" "$TEMPLATE_NAME" "$S3_TEMPLATES_COMMON_PATH"

  echo "Validating the auth cf template..."
  # validating the cf template
  validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/$TEMPLATE_NAME"
}

