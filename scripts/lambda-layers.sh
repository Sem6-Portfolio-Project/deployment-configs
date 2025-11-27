#!/bin/bash

source './params.sh'
source './utils.sh'

DIST="$LAYERS_DIR/node-module"

#This will create layer zip
create_layer_zip() {
  set -e

  layer_name=$1

  echo "Creating $layer_name layer ZIP..."
  cd "$DIST"

  echo "Updating dependencies..."
  npm prune --production

  cd "$DIST" && zip -9vr "$layer_name" "node_modules"

  set +e
}


# This will update the lambda layers
upload_lambda_layer_to_s3() {
  layer_name=$1

  echo "Uploading the $layer_name lambda layer to s3..."

  s3_sync "$LAYERS_DIR/node-module" "$layer_name.zip" "$S3_LAYERS_COMMON_PATH"

}

update_lambda_layer() {
  aws lambda publish-layer-version \
    --layer-name NodeModuleLayer \
    --content S3Bucket=$RESOURCE_BUCKET_NAME,S3Key="$S3_LAYERS_COMMON_PATH/lambda_node_layer.zip" \
    --region $AWS_REGION

}