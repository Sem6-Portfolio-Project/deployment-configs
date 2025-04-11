#!/bin/bash

source './params.sh'


#Helper functions
#Error message
echo_error() {
    echo -e "\033[31m$1\033[0m" >&2
}
#Error and exit
error_and_exit() {
  echo -e "\033[31m$1\033[0m" >&2
  exit 1
}
#Success message
echo_success() {
    echo -e "\033[32m$1\033[0m"
}

# This will build the project and create zip file contains the source code
#      dist=$1 : Distribution destination ( build files store here)
#      backend=$2 : Path to the backend project
#      zip_file_name=$3 : Name of the build zip file

build_backend_and_create_zip() {
    dist=$1
    backend=$2
    zip_file_name=$3

    set -e

    echo "Building backend ZIP..."

    mkdir -p "$dist/"
    rm -rf "$dist"
    cd "$backend"

    echo "Updating dependencies..."
    npm ci

    echo "Compiling Typescript code to Javascript..."
    npx tsc

    echo $(git rev-parse --short=7 HEAD) \
    $([[ "$(git status --porcelain --untracked-files=no)" == "" ]] && echo "ok" || echo "tainted") \
    $USERNAME@${HOSTNAME:-$COMPUTERNAME} $(date +%s000) \
    > dist/BUILD

    cd -

    cd "$dist" && zip -9vr "$zip_file_name"\
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
    --exclude="*" --include="$source_key" || echo_error "Error while uploading $source_key."

#  aws s3 ls s3://$RESOURCE_BUCKET_NAME/ --recursive --human-readable --summarize --profile "$AWS_PROFILE"
}

# This will upload build zip file to the S3 bucket.
#    dist=$1 : Distribution directory ( build files directory )
#    zip_file_name=$2
#    s3_dir_lambda_code=$3 : s3 url for the code
upload_build_project_to_s3() {
  dist=$1
  zip_file_name=$2
  s3_dir_lambda_code=$3
  s3_sync "$dist" "$zip_file_name.zip" "$s3_dir_lambda_code"
}

# This will upload the CF templates
#    template_dir=$1 : local directory of the template
#    template_name=$2 : template name
#    s3_template_common_path=$3 : s3 url for the template directory
upload_cf_template() {
  template_dir=$1
  template_name=$2
  s3_template_common_path=$3
  s3_sync "$template_dir" "$template_name" "$s3_template_common_path"
}

# This will validate the cf template
validate_cf_template() {
  template_s3_url=$1
  echo "Validating the $template_s3_url template."

  output=$(
    aws cloudformation validate-template \
      --profile "$AWS_PROFILE" \
      --region "$AWS_REGION"\
      --template-url "$template_s3_url" 2>&1
   )

  if [[ $? -ne 0 ]]; then
    echo_error "Validation error for template:"
    echo_error "$template_s3_url"
    echo_error "$output"
    exit 1
  fi
}



