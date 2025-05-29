#!/bin/bash

export CUR_DIR=$(pwd)

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  export NULL_DEVICE="NUL"
else
  export NULL_DEVICE="/dev/null"
fi

#This will give project root. (/../..) change accordingly based on the project setup
export PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)/../.."

#Project directories
export AUTH_BACKEND="$PROJECT_ROOT/mobile-app-backend-auth"
export BUS_MANAGE_BACKEND="$PROJECT_ROOT/bus-tracking-and-scheduling"
export GENERAL_SERVICES_BACKEND="$PROJECT_ROOT/general-services-hub"
export LAYERS_DIR="$PROJECT_ROOT/layers"

#Template directories
export TEMPLATE_DIR="$PROJECT_ROOT/deployment-configs/cf-templates"

#Credintials
export AWS_PROFILE=project
region=$(aws configure get region --profile "$AWS_PROFILE")
export AWS_REGION=$region
export S3_DOMAIN_URL="https://s3.$AWS_REGION.amazonaws.com"
export RESOURCE_BUCKET_NAME="481665090781-mobile-app-resources"
export S3_LAMBDA_COMMON_PATH="source-code/lambdas"
export S3_TEMPLATES_COMMON_PATH="deployment-configs/templates"
export S3_LAYERS_COMMON_PATH="layers"

#Customers related sources
export CustomerResourcesBucketARN="arn:aws:s3:::481665090781-customer-resources"


#params
export ConsoleUrl="www.google.com"
export Stage="dev"
export PlatformApplicationARN="arn:aws:sns:us-east-1:481665090781:app/GCM/FCM-integration"

export NodeLayerARN="arn:aws:lambda:us-east-1:481665090781:layer:NodeModuleLayer:27"
export NotificationQueueUrl="https://sqs.us-east-1.amazonaws.com/481665090781/NotificationQueue"
export NotificationQueueARN="arn:aws:sqs:us-east-1:481665090781:NotificationQueue"
export WebsocketId="r30xifcyw3"
export BusProxyID="5ryos4"
export GeneralProxyID="7titun"
export WSEndpointUrl="https://r30xifcyw3.execute-api.us-east-1.amazonaws.com/wb-dev/"
export RestApiID="i5ru7zdp4k"
export AuthProxyID="91x9y1"
export UserPoolClientID="5r5g4lmi9bravo68pens1jgs4c"
export AuthLambdaARN="arn:aws:lambda:us-east-1:481665090781:function:AuthLambda"
export UserPoolId="us-east-1_NW5D6OWcv"
export VehicleStateLogsARN="arn:aws:dynamodb:us-east-1:481665090781:table/VehicleStateLogs"
export WebSocketConnBusesARN="arn:aws:dynamodb:us-east-1:481665090781:table/WebSocketConnBuses"
export BusLambdaARN="arn:aws:lambda:us-east-1:481665090781:function:BusLambda"
export WebSocketConnMapperARN="arn:aws:dynamodb:us-east-1:481665090781:table/WebSocketConnMapper"
export BusesARN="arn:aws:dynamodb:us-east-1:481665090781:table/Buses"
export WSConnectLambdaARN="arn:aws:lambda:us-east-1:481665090781:function:WSConnectLambda"
export WSSendLocationLambdaARN="arn:aws:lambda:us-east-1:481665090781:function:WSSendLocationLambda"
export WebSocketConnPassengersARN="arn:aws:dynamodb:us-east-1:481665090781:table/WebSocketConnPassengers"
export WSDisconnectLambdaARN="arn:aws:lambda:us-east-1:481665090781:function:WSDisconnectLambda"
export PlatformEndpointsARN="arn:aws:dynamodb:us-east-1:481665090781:table/PlatformEndpoints"
export LostAndFoundItems="arn:aws:dynamodb:us-east-1:481665090781:table/LostAndFoundItems"
export NotificationLambdaARN="arn:aws:lambda:us-east-1:481665090781:function:NotificationInvoker"
export Notifications="arn:aws:dynamodb:us-east-1:481665090781:table/Notifications"
export GeneralServiceLambdaARN="arn:aws:lambda:us-east-1:481665090781:function:GeneralServiceLambda"
