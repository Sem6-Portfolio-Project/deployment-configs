#!/bin/bash

source './params.sh'
source './utils.sh'

# This is distribution destination
DIST="$BUS_MANAGE_BACKEND/dist"

ZIP_FILE_NAME_BACKEND='build_backend_bus_management'
S3_DIR_LAMBDA_CODE="$S3_LAMBDA_COMMON_PATH/backend-bus"
TEMPLATE_NAME="bus-management.yaml"

build_and_upload_bus_manage_backend_code() {
  echo "Building the bus management backend code..."
  # Build the bus management backend and create the zip folder
  build_backend_and_create_zip "$DIST" "$BUS_MANAGE_BACKEND" "$ZIP_FILE_NAME_BACKEND"

  echo "Uploading the bus management backend code..."
  # Upload build zip file to the S3 bucket.
  upload_build_project_to_s3 "$DIST" "$ZIP_FILE_NAME_BACKEND" "$S3_DIR_LAMBDA_CODE"
}

upload_and_validate_bus_manage_cf_template() {
  echo "Uploading the bus cf template..."
  # Upload the CF template to the s3 bucket
  upload_cf_template "$TEMPLATE_DIR" "$TEMPLATE_NAME" "$S3_TEMPLATES_COMMON_PATH"

  echo "Validating the bus cf template..."
  # validating the cf template
  validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/$TEMPLATE_NAME"
}
