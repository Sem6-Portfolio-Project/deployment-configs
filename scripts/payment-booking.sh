#!/bin/bash

source './params.sh'
source './utils.sh'
source './update-lambda.sh'

# This is distribution destination
DIST_BOOKING_PAYMENT="$BOOKING_PAYMENT_BACKEND/dist"

ZIP_FILE_NAME_BOOKING_PAYMENT_BACKEND='build_booking_payment_management'
S3_DIR_LAMBDA_CODE_FOR_BOOKING_PAYMENT="$S3_LAMBDA_COMMON_PATH/backend-booking-payment"
TEMPLATE_NAME_FOR_BOOKING_PAYMENT="booking-and-payment.yaml"

build_and_upload_payment_booking_backend_code() {
  echo "Building the payment and booking backend code..."
  # Build the payment and booking backend and create the zip folder
  build_backend_and_create_zip "$DIST_BOOKING_PAYMENT" "$BOOKING_PAYMENT_BACKEND" "$ZIP_FILE_NAME_BOOKING_PAYMENT_BACKEND"

  echo "Uploading the payment and booking backend code..."
  # Upload build zip file to the S3 bucket.
  upload_build_project_to_s3 "$DIST_BOOKING_PAYMENT" "$ZIP_FILE_NAME_BOOKING_PAYMENT_BACKEND" "$S3_DIR_LAMBDA_CODE_FOR_BOOKING_PAYMENT"
}

upload_and_validate_payment_booking_cf_template() {
  echo "Uploading the payment and booking cf template..."
  # Upload the CF template to the s3 bucket
  upload_cf_template "$TEMPLATE_DIR" "$TEMPLATE_NAME_FOR_BOOKING_PAYMENT" "$S3_TEMPLATES_COMMON_PATH"

  echo "Validating the payment and booking cf template..."
  # validating the cf template
  validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/$TEMPLATE_NAME_FOR_BOOKING_PAYMENT"
}

update_booking_lambda() {
  build_and_upload_payment_booking_backend_code
  update_lambda_code "BookingLambda" "$S3_DIR_LAMBDA_CODE_FOR_BUS/$ZIP_FILE_NAME_BOOKING_PAYMENT_BACKEND.zip"
}

update_PaymentHandleInvoker_lambda() {
  build_and_upload_payment_booking_backend_code
  update_lambda_code "PaymentHandleInvokerLambda" "$S3_DIR_LAMBDA_CODE_FOR_BUS/$ZIP_FILE_NAME_BOOKING_PAYMENT_BACKEND.zip"
}

update_SeatsUnlockInvoker_lambda() {
  build_and_upload_payment_booking_backend_code
  update_lambda_code "SeatsUnlockInvokerLambda" "$S3_DIR_LAMBDA_CODE_FOR_BUS/$ZIP_FILE_NAME_BOOKING_PAYMENT_BACKEND.zip"
}
