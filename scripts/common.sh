#!/bin/bash

source './params.sh'
source './utils.sh'
source './lambda-layers.sh'
source './stack-deployment.sh'

# Deploying the lambda layer
echo "Deploying the node module layer..."
# create_layer_zip "lambda_node_layer"
# upload_lambda_layer_to_s3 "lambda_node_layer"

upload_cf_template "$TEMPLATE_DIR" "common-resource.yaml" "$S3_TEMPLATES_COMMON_PATH"
validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/common-resource.yaml"

PARAMS=$(stack_params_for_common_resources)
deploy_cf_stack "common-resources" "common-resource.yaml" "$PARAMS"

# Deploying the main stack ( api + websocket )
echo "Deploying the main stack..."
upload_cf_template "$TEMPLATE_DIR" "main-stack.yaml" "$S3_TEMPLATES_COMMON_PATH"
validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/main-stack.yaml"

PARAMS=$(stack_params_for_main_stack)
deploy_cf_stack "main-resources" "main-stack.yaml" "$PARAMS"
