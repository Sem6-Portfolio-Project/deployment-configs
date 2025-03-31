#!/bin/bash

source "./utils.sh"

#This will deploy the cf stack
deploy_cf_stack() {
  stack_name=$1
  template_name=$2
  params=$3

  if [[ -z "$stack_name" || -z "$template_name" || -z "$params" ]] ;  then
    echo_error "Error: Missing arguments"
    echo_error "Usage: deploy_cf_stack <stack_name> <template_name> <parameters>"
    exit 1
  fi

  echo "Creating the $template_name stack deployment..."

  aws cloudformation create-stack \
      --profile $AWS_PROFILE \
      --region $AWS_REGION \
      --stack-name $stack_name \
      --template-url "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/$template_name" \
      --parameters $params \
      --capabilities CAPABILITY_NAMED_IAM || error_and_exit "Error while creating the $template_name stack."

  echo "Waiting for the $template_name stack deployment..."
  aws cloudformation wait stack-create-complete \
      --profile "$AWS_PROFILE" \
      --region "$AWS_REGION" \
      --stack-name "$stack_name"  || error_and_exit "Error while deploying the $template_name stack"

  echo_success "Successfully deployed the $template_name stack."
}

#This will create stack changes set.
create_changes_set() {
  #TODO
  set -e
}

#This will update the cf stack
update_changes_set() {
  set -e
}

stack_params() {

  declare -A params_map
  params_map["ResourceBucket"]="$RESOURCE_BUCKET_NAME"
  params_map["LambdaCodeKey"]="$S3_LAMBDA_COMMON_PATH/backend-auth/build_backend_auth.zip"
  params_map["NodeLayerCodeKey"]="$S3_LAYERS_COMMON_PATH/lambda_node_layer.zip"
  params_map["AppConsoleUrl"]="$ConsoleUrl"

  # Prepare parameters for CloudFormation
  param_string=""
  for key in "${!params_map[@]}"; do
    param_string+="ParameterKey=$key,ParameterValue=${params_map[$key]} "
  done

  echo "$param_string"
}

PARAMS=$(stack_params)
deploy_cf_stack "user-management" "user-management.yaml" "$PARAMS"
