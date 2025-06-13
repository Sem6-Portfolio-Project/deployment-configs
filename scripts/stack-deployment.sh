#!/bin/bash

source './params.sh'
source './utils.sh'

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

  echo "Fetching stack outputs..."
  stack_outputs=$(aws cloudformation describe-stacks \
      --profile "$AWS_PROFILE" \
      --region "$AWS_REGION" \
      --stack-name "$stack_name" \
      --query "Stacks[0].Outputs" \
      --output json)

  # Loop through each output and write it dynamically to ./params.sh
  echo "$stack_outputs" | jq -r '.[] | "export \(.OutputKey)=\"\(.OutputValue)\""' | while read line; do
    # Extract the environment variable name (before the "=" sign)
    var_name=$(echo "$line" | cut -d'=' -f1)

    # Check if the variable exists in params.sh
    if grep -q "^$var_name=" ./params.sh; then
      # If the variable exists, replace it with the new value using sed
      echo "replaced $var_name"
      sed -i "/^$var_name=/c\\$line" ./params.sh
    else
      # If the variable doesn't exist, append it
      echo "appended $var_name"
      echo "$line" >> ./params.sh
    fi
  done


  echo "Stack outputs have been written to ./params.sh"
}

#This will create stack changes set.
create_changes_set() {
  #TODO
  set -e
}

#This will update the cf stack
update_changes_set() {
   #TODO
  set -e
}

# This will create the common stack params.
stack_params_for_common_resources() {

  declare -A params_map
  params_map["ResourceBucket"]="$RESOURCE_BUCKET_NAME"
  params_map["NodeLayerCodeKey"]="$S3_LAYERS_COMMON_PATH/lambda_node_layer.zip"

  # Prepare parameters for CloudFormation
  param_string=""
  for key in "${!params_map[@]}"; do
    param_string+="ParameterKey=$key,ParameterValue=${params_map[$key]} "
  done

  echo "$param_string"
}

# This will create the stack params for the user management.
stack_params_for_user_management() {

  declare -A params_map
  params_map["ResourceBucket"]="$RESOURCE_BUCKET_NAME"
  params_map["LambdaCodeKey"]="$S3_LAMBDA_COMMON_PATH/backend-auth/build_backend_auth.zip"
  params_map["NodeLayerARN"]="$NodeLayerARN"
  params_map["AppConsoleUrl"]="$ConsoleUrl"
  params_map["NotificationQueueARN"]="$NotificationQueueARN"
  params_map["NotificationQueueUrl"]="$NotificationQueueUrl"
  

  # Prepare parameters for CloudFormation
  param_string=""
  for key in "${!params_map[@]}"; do
    param_string+="ParameterKey=$key,ParameterValue=${params_map[$key]} "
  done

  echo "$param_string"
}

# This will create the stack params for the bus management.
stack_params_for_bus_management() {

  declare -A params_map
  params_map["ResourceBucket"]="$RESOURCE_BUCKET_NAME"
  params_map["LambdaCodeKey"]="$S3_LAMBDA_COMMON_PATH/backend-bus/build_backend_bus_management.zip"
  params_map["NodeLayerARN"]="$NodeLayerARN"
  params_map["AppConsoleUrl"]="$ConsoleUrl"
  params_map["WSEndpointUrl"]="$WSEndpointUrl"
  params_map["WebsocketId"]="$WebsocketId"
  params_map["NotificationQueueARN"]="$NotificationQueueARN"
  params_map["NotificationQueueUrl"]="$NotificationQueueUrl"

  # Prepare parameters for CloudFormation
  param_string=""
  for key in "${!params_map[@]}"; do
    param_string+="ParameterKey=$key,ParameterValue=${params_map[$key]} "
  done

  echo "$param_string"
}

# This will create the stack params for the main-stack-integration.
stack_params_for_main_stack_integration() {

  declare -A params_map
  params_map["AuthLambdaARN"]="$AuthLambdaARN"
  params_map["BusLambdaARN"]="$BusLambdaARN"
  params_map["BookingLambdaARN"]="$BookingLambdaARN"
  params_map["GeneralServiceLambdaARN"]="$GeneralServiceLambdaARN"
  params_map["PaymentHandleInvokerLambdaARN"]="$PaymentHandleInvokerLambdaARN"
  params_map["WSConnectLambdaARN"]="$WSConnectLambdaARN"
  params_map["WSDisconnectLambdaARN"]="$WSDisconnectLambdaARN"
  params_map["WSSendLocationLambdaARN"]="$WSSendLocationLambdaARN"
  params_map["AuthProxyID"]="$AuthProxyID"
  params_map["BusProxyID"]="$BusProxyID" 
  params_map["BookingProxyID"]="$BookingProxyID"
  params_map["PayhereNotifyPostID"]="$PayhereNotifyPostID"
  params_map["GeneralProxyID"]="$GeneralProxyID"
  params_map["RestApiID"]="$RestApiID"
  params_map["WebsocketId"]="$WebsocketId"
  params_map["Stage"]="$Stage"

  # Prepare parameters for CloudFormation
  param_string=""
  for key in "${!params_map[@]}"; do
    param_string+="ParameterKey=$key,ParameterValue=${params_map[$key]} "
  done

  echo "$param_string"
}

# This will create the stack params for the main-stack.
stack_params_for_main_stack() {

  declare -A params_map
  params_map["Stage"]="$Stage"

  # Prepare parameters for CloudFormation
  param_string=""
  for key in "${!params_map[@]}"; do
    param_string+="ParameterKey=$key,ParameterValue=${params_map[$key]} "
  done

  echo "$param_string"
}

# This will create the stack params for the general-services stack.
stack_params_for_general_services_stack() {

  declare -A params_map
  params_map["ResourceBucket"]="$RESOURCE_BUCKET_NAME"
  params_map["LambdaCodeKey"]="$S3_LAMBDA_COMMON_PATH/backend-general/build_general_services_hub.zip"
  params_map["NodeLayerARN"]="$NodeLayerARN"
  params_map["AppConsoleUrl"]="$ConsoleUrl"
  params_map["PlatformApplicationARN"]="$PlatformApplicationARN"
  params_map["CustomerResourcesBucketARN"]="$CustomerResourcesBucketARN"
  params_map["NotificationQueueARN"]="$NotificationQueueARN"
  params_map["NotificationQueueUrl"]="$NotificationQueueUrl"

  # Prepare parameters for CloudFormation
  param_string=""
  for key in "${!params_map[@]}"; do
    param_string+="ParameterKey=$key,ParameterValue=${params_map[$key]} "
  done

  echo "$param_string"
}

# This will create the stack params for the booking and payment services stack.
stack_params_for_booking_and_payment_services_stack() {

  declare -A params_map
  params_map["ResourceBucket"]="$RESOURCE_BUCKET_NAME"
  params_map["LambdaCodeKey"]="$S3_LAMBDA_COMMON_PATH/backend-booking-payment/build_booking_payment_management.zip"
  params_map["NodeLayerARN"]="$NodeLayerARN"
  params_map["AppConsoleUrl"]="$ConsoleUrl"
  params_map["PlatformEndpointsARN"]="$PlatformEndpointsARN"
  params_map["NotificationQueueARN"]="$NotificationQueueARN"
  params_map["NotificationQueueUrl"]="$NotificationQueueUrl"
  params_map["PayhereNotifyUrl"]="$PayhereNotifyUrl"
  params_map["PayhereMarchantID"]="$PayhereMarchantID"
  params_map["PayhereMarchantSecret"]="$PayhereMarchantSecret"
  params_map["StripeSecretKey"]="$StripeSecretKey"
  params_map["BusesARN"]="$BusesARN"

  # Prepare parameters for CloudFormation
  param_string=""
  for key in "${!params_map[@]}"; do
    param_string+="ParameterKey=$key,ParameterValue=${params_map[$key]} "
  done

  echo "$param_string"
}

# This will upload and validate the main stack integration template.
upload_and_validate_main_stack_integration_cf_template() {
    echo "Uploading the main stack integration cf template..."
    # Upload the CF template to the s3 bucket
    upload_cf_template "$TEMPLATE_DIR" "main-stack-integration.yaml" "$S3_TEMPLATES_COMMON_PATH"

    echo "Validating the main stack integration cf template..."
    # validating the cf template
    validate_cf_template "$S3_DOMAIN_URL/$RESOURCE_BUCKET_NAME/$S3_TEMPLATES_COMMON_PATH/main-stack-integration.yaml"
}
