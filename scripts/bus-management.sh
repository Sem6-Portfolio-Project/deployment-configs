#!/bin/bash

source './params.sh'
source './utils.sh'
source './update-lambda.sh'

# This is distribution destination
DIST_BUS="$BUS_MANAGE_BACKEND/dist"

ZIP_FILE_NAME_BUS_BACKEND='build_backend_bus_management'
S3_DIR_LAMBDA_CODE_FOR_BUS="$S3_LAMBDA_COMMON_PATH/backend-bus"
TEMPLATE_NAME_FOR_BUS="bus-management.yaml"

build_and_upload_bus_manage_backend_code() {
  echo "Building the bus management backend code..."
  # Build the bus management backend and create the zip folder
  build_backend_and_create_zip "$DIST_BUS" "$BUS_MANAGE_BACKEND" "$ZIP_FILE_NAME_BUS_BACKEND"

  echo "Uploading the bus management backend code..."
  # Upload build zip file to the S3 bucket.
  upload_build_project_to_s3 "$DIST_BUS" "$ZIP_FILE_NAME_BUS_BACKEND" "$S3_DIR_LAMBDA_CODE_FOR_BUS"
}

upload_and_validate_bus_manage_cf_template() {
  echo "Uploading the bus cf template..."
  # Upload the CF template to the s3 bucket
  upload_cf_template "$TEMPLATE_DIR" "$TEMPLATE_NAME_FOR_BUS" "$S3_TEMPLATES_COMMON_PATH"

  echo "Validating the bus cf template..."
  # validating the cf template
  validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/$TEMPLATE_NAME_FOR_BUS"
}

update_bus_lambda() {
  build_and_upload_bus_manage_backend_code
  update_lambda_code "BusLambda" "$S3_DIR_LAMBDA_CODE_FOR_BUS/$ZIP_FILE_NAME_BUS_BACKEND.zip"
}
