#!/bin/bash

export CUR_DIR=$(pwd)

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  export NULL_DEVICE="NUL"
else
  export NULL_DEVICE="/dev/null"
fi

#This will give project root. (/../..) change accordingly based on the project setup
export PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd) /../.."

#Project directories
export AUTH_BACKEND="$PROJECT_ROOT/mobile-app-backend-auth"
export BUS_MANAGE_BACKEND="$PROJECT_ROOT/bus-tracking-and-scheduling"
export LAYERS_DIR="$PROJECT_ROOT/layers"

#Template directories
export TEMPLATE_DIR="$PROJECT_ROOT/deployment-configs/cf-templates"

#Credintials
export AWS_PROFILE=personal
#region=$(aws configure get region --profile "$AWS_PROFILE")
#export AWS_REGION=$region
export AWS_REGION='ap-southeast-1'
export S3_DOMAIN_URL="https://s3.$AWS_REGION.amazonaws.com"
#export RESOURCE_BUCKET_NAME="481665090781-mobile-app-resources"
export RESOURCE_BUCKET_NAME="481665090781-mobile-app-resources-as"
export S3_LAMBDA_COMMON_PATH="source-code/lambdas"
export S3_TEMPLATES_COMMON_PATH="deployment-configs/templates"
export S3_LAYERS_COMMON_PATH="layers"

#params
export ConsoleUrl="www.google.com"
export Stage="dev"


export NodeLayerARN="arn:aws:lambda:ap-southeast-1:481665090781:layer:NodeModuleLayer:4"
export WebsocketId="u3hxqw7rsd"
export BusProxyID="ao06da"
export WSEndpointUrl="https://u3hxqw7rsd.execute-api.ap-southeast-1.amazonaws.com/wb-dev/@connections"
export RestApiID="y3d13y3gk8"
export AuthProxyID="obk2u9"
export UserPoolClientID="4aco864mp0qn358f22g776c31j"
export AuthLambdaARN="arn:aws:lambda:ap-southeast-1:481665090781:function:AuthLambda"
export UserPoolId="ap-southeast-1_0gA8fs8KO"
export VehicleStateLogsARN="arn:aws:dynamodb:ap-southeast-1:481665090781:table/VehicleStateLogs"
export WebSocketConnBusesARN="arn:aws:dynamodb:ap-southeast-1:481665090781:table/WebSocketConnBuses"
export BusLambdaARN="arn:aws:lambda:ap-southeast-1:481665090781:function:BusLambda"
export BusesARN="arn:aws:dynamodb:ap-southeast-1:481665090781:table/Buses"
export WSConnectLambdaARN="arn:aws:lambda:ap-southeast-1:481665090781:function:WSConnectLambda"
export WSSendLocationLambdaARN="arn:aws:lambda:ap-southeast-1:481665090781:function:WSSendLocationLambda"
export WebSocketConnPassengersARN="arn:aws:dynamodb:ap-southeast-1:481665090781:table/WebSocketConnPassengers"
export WSDisconnectLambdaARN="arn:aws:lambda:ap-southeast-1:481665090781:function:WSDisconnectLambda"
