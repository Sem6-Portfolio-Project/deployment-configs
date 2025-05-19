#!/bin/bash

source './params.sh'
source './utils.sh'
source './update-lambda.sh'

# This is distribution destination
DIST_GENERAL="$GENERAL_SERVICES_BACKEND/dist"

ZIP_FILE_NAME_GENERAL_SERVICES_BACKEND='build_general_services_hub'
S3_DIR_LAMBDA_CODE_FOR_GENERAL_SERVICES="$S3_LAMBDA_COMMON_PATH/backend-general"
TEMPLATE_NAME_FOR_GENERAL_SERVIVES="general-service.yaml"

build_and_upload_general_services_hub() {
  echo "Building the general services hub..."
  # Build the general services hub and create the zip folder
  build_backend_and_create_zip "$DIST_GENERAL" "$GENERAL_SERVICES_BACKEND" "$ZIP_FILE_NAME_GENERAL_SERVICES_BACKEND"

  echo "Uploading the general service backend code..."
  # Upload build zip file to the S3 bucket.
  upload_build_project_to_s3 "$DIST_GENERAL" "$ZIP_FILE_NAME_GENERAL_SERVICES_BACKEND" "$S3_DIR_LAMBDA_CODE_FOR_GENERAL_SERVICES"
}

upload_and_validate_general_service_cf_template() {
  echo "Uploading the general service cf template..."
  # Upload the CF template to the s3 bucket
  upload_cf_template "$TEMPLATE_DIR" "$TEMPLATE_NAME_FOR_GENERAL_SERVIVES" "$S3_TEMPLATES_COMMON_PATH"

  echo "Validating the general service cf template..."
  # validating the cf template
  validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/$TEMPLATE_NAME_FOR_GENERAL_SERVIVES"
}

update_notification_invoker_lambda() {
  build_and_upload_general_services_hub
  update_lambda_code "NotificationInvoker" "$S3_DIR_LAMBDA_CODE_FOR_GENERAL_SERVICES/$ZIP_FILE_NAME_GENERAL_SERVICES_BACKEND.zip"
}

update_general_service_lambda() {
  build_and_upload_general_services_hub
  update_lambda_code "GeneralServiceLambda" "$S3_DIR_LAMBDA_CODE_FOR_GENERAL_SERVICES/$ZIP_FILE_NAME_GENERAL_SERVICES_BACKEND.zip"
}
