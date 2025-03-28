#!/bin/bash

source "./utils.sh"

# This is distribution destination
DIST="$AUTH_BACKEND/dist"
ZIP_FILE_NAME_BACKEND='build_backend_auth'
S3_DIR_LAMBDA_CODE="$S3_LAMBDA_COMMON_PATH/backend-auth"
TEMPLATE_NAME="user-management.yaml"


# This will build the project and create zip file contains the source code
build_backend_auth_zip() {
    set -e

    echo "Building auth backend ZIP..."

    mkdir -p "$DIST/"
    rm -rf "$DIST"
    cd "$AUTH_BACKEND"

    echo "Updating dependencies..."
    npm ci

    echo "Compiling Typescript code to Javascript..."
    npx tsc

    echo $(git rev-parse --short=7 HEAD) \
    $([[ "$(git status --porcelain --untracked-files=no)" == "" ]] && echo "ok" || echo "tainted") \
    $USERNAME@${HOSTNAME:-$COMPUTERNAME} $(date +%s000) \
    > dist/BUILD

    cd -

    cd "$DIST" && zip -9vr "$ZIP_FILE_NAME_BACKEND" \
      lib/ ../package.json ../package-lock.json BUILD

    cd -
    set +e
}

# Synchronize specific file from local source directory to s3 bucket.
# params
#   $1 - The local source directory.
#   $2 - The name of the file to upload.
#   $3 - The destination directory in the S3 bucket.
s3_sync() {
  local source_dir=$1
  local source_key=$2
  local dest_dir=$3

#  echo "$source_dir"
#  echo "$source_key"
#  echo "$dest_dir"

  if [[ -z "$source_dir" || -z "$source_key" || -z "$dest_dir" ]]; then
    echo_error "Error: Missing arguments"
    echo_error "Usage: s3_sync <source_dir> <source_key> <des_dir>"
    exit 1
  fi

  echo "Uploading $source_key to S3 bucket $dest_dir"
  aws s3 sync --profile "$AWS_PROFILE" \
    "$source_dir" "s3://$RESOURCE_BUCKET_NAME/$dest_dir" \
    --exclude="*" --include="$source_key"

#  aws s3 ls s3://$RESOURCE_BUCKET_NAME/ --recursive --human-readable --summarize --profile "$AWS_PROFILE"
}
# This will upload build zip file to the S3 bucket.
upload_build_project_to_s3() {
  s3_sync "$DIST" "$ZIP_FILE_NAME_BACKEND.zip" "$S3_DIR_LAMBDA_CODE"
}

# This will upload the CF templates
upload_cf_template() {
  s3_sync "$TEMPLATE_DIR" "$TEMPLATE_NAME" "$S3_TEMPLATES_COMMON_PATH"
}

# This will validate the cf template
validate_cf_template() {
  local template_s3_url=$1
  echo "Validating the $template_s3_url template."

  output=$(
    aws cloudformation validate-template \
      --profile "$AWS_PROFILE" \
      --region "$AWS_REGION"\
      --template-url "$template_s3_url" 2>&1
   )

  if [[ $? -eq 0 ]]; then
    echo_success "Successfully validated the CloudFormation template."
    exit 0
  else
    echo_error "Validation error for template:"
    echo_error "$template_s3_url"
    echo_error "$output"
    exit 1
  fi
}

#build_backend_auth_zip
#upload_build_project_to_s3
upload_cf_template
validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/$TEMPLATE_NAME"