#!/bin/bash

source './utils.sh'
source './user-management.sh'
source './stack-deployment.sh'
source './bus-management.sh'
source './general-services.sh'
source './payment-booking.sh'

echo "OPTIONS"
echo "1.Deploy"
echo "2.Update"

runner() {
  echo -n "Please enter option : "
  read user_input

  if [[ -z "$user_input" ]] ;then
    error_and_exit "Missing selected option.."
  fi

  echo "Selected option id : $user_input"

  if [[ "$user_input" = 1  ]] ;then
    echo "DEPLOYMENT OPTIONS"
    echo "1.Deploy User-management stack"
    echo "2.Deploy Bus-management stack"
    echo "3.Deploy General-services stack"
    echo "4.Deploy booking-payment management stack"
    echo "5.Deploy main-stack-integration stack"
    echo "6.All"

    echo "PLEASE NOTE THAT IF YOU ALREADY DIDN'T DEPLOY THE COMMON STACK , PLEASE DEPLOY IT FIRST BY RUNNING 'common.sh'"
    echo -n "Please enter option : "
    read input

    if [[ -z "$input" ]] ;then
      error_and_exit "Missing selected option.."
    fi

    echo "Selected option id : $input"

    if [[ "$input" = 1 ]] ;then
      echo "Deploying user management stack..."
      build_and_upload_auth_backend_code
      upload_and_validate_auth_cf_template
      PARAMS=$(stack_params_for_user_management)
      deploy_cf_stack "user-management" "user-management.yaml" "$PARAMS"
    elif [[ "$input" = 2 ]] ;then
      echo "Deploying bus management stack..."
      build_and_upload_bus_manage_backend_code
      upload_and_validate_bus_manage_cf_template
      PARAMS=$(stack_params_for_bus_management)
      deploy_cf_stack "bus-management" "bus-management.yaml" "$PARAMS"
    elif [[ "$input" = 3 ]] ;then
      echo "Deploying general services stack..."
      build_and_upload_general_services_hub
      upload_and_validate_general_service_cf_template
      PARAMS=$(stack_params_for_general_services_stack)
      deploy_cf_stack "general-service-hub" "general-service.yaml" "$PARAMS"
    elif [[ "$input" = 4 ]]; then
      echo "Deploying booking-payment management stack..."
      build_and_upload_payment_booking_backend_code
      upload_and_validate_payment_booking_cf_template
      PARAMS=$(stack_params_for_booking_and_payment_services_stack)
      deploy_cf_stack "booking-payment-management" "booking-and-payment.yaml" "$PARAMS"
    elif [[ "$input" = 5 ]]; then
      echo "Deploying main stack integration stack..."
      upload_and_validate_main_stack_integration_cf_template
      PARAMS=$(stack_params_for_main_stack_integration)
      deploy_cf_stack "main-stack-integration" "main-stack-integration.yaml" "$PARAMS"
    elif [[ "$input" = 6 ]]; then
      echo "Deploying user management stack..."
      build_and_upload_auth_backend_code
      upload_and_validate_auth_cf_template
      PARAMS=$(stack_params_for_user_management)
      deploy_cf_stack "user-management" "user-management.yaml" "$PARAMS"

      echo "Deploying bus management stack..."
      build_and_upload_bus_manage_backend_code
      upload_and_validate_bus_manage_cf_template
      PARAMS=$(stack_params_for_bus_management)
      deploy_cf_stack "bus-management" "bus-management.yaml" "$PARAMS"

      echo "Deploying general services stack..."
      build_and_upload_general_services_hub
      upload_and_validate_general_service_cf_template
      PARAMS=$(stack_params_for_general_services_stack)
      deploy_cf_stack "general-service-hub" "general-service.yaml" "$PARAMS"

      echo "Deploying booking-payment management stack..."
      build_and_upload_payment_booking_backend_code
      upload_and_validate_payment_booking_cf_template
      PARAMS=$(stack_params_for_booking_and_payment_services_stack)
      deploy_cf_stack "booking-payment-management" "booking-and-payment.yaml" "$PARAMS"

      echo "Deploying main stack integration stack..."
      upload_and_validate_main_stack_integration_cf_template
      PARAMS=$(stack_params_for_main_stack_integration)
      deploy_cf_stack "main-stack-integration" "main-stack-integration.yaml" "$PARAMS"
    fi
  elif [[ "$user_input" = 2 ]]; then
    echo "UPDATE OPTIONS"
    echo "1.Update User-management lambdas"
    echo "2.Update Bus-management lambdas"
    echo "3.Update WSConnect lambdas"
    echo "4.Update WSDisconnect lambdas"
    echo "5.Update WSSendLocation lambdas"
    echo "6.Update Notification invoker lambda"
    echo "7.Update general service lambda"
    echo "8.Update booking service lambda"
    echo "9.Update seats-unlock invoker lambda"
    echo "10.Update payhere notify invoker lambda"            
    echo "11.All lambdas"

    echo -n "Please enter option : "
    read input

    if [[ -z "$input" ]] ;then
      error_and_exit "Missing selected option.."
    fi

    echo "Selected option id : $input"

    if [[ "$input" = 1 ]] ;then
      echo "Updating user management lambdas..."
      update_auth_lambda
    elif [[ "$input" = 2 ]] ;then
      echo "Updating bus management lambdas..."
      update_bus_lambda
    elif  [[ "$input" = 3 ]] ;then
      echo "Updating WSConnect lambdas..."
      update_WSConnect_lambda
    elif [[ "$input" = 4 ]] ;then
      echo "Updating WSDisconnect lambdas..."
      update_WSDisconnect_lambda
    elif [[ "$input" = 5 ]] ;then
      echo "Updating WSSendLocation lambdas..."
      update_WSSendLocation_lambda
    elif [[ "$input" = 6 ]] ;then
      echo "Updating Notification invoker lambda..."
      update_notification_invoker_lambda
    elif [[ "$input" = 7 ]] ;then
      echo "Updating general service lambda..."
      update_general_service_lambda
    elif [[ "$input" = 8 ]] ;then
      echo "Updating booking service lambda..."
      update_booking_lambda
    elif [[ "$input" = 9 ]] ;then
      echo "Updating seats-unlock invoker lambda..."
      update_SeatsUnlockInvoker_lambda
    elif [[ "$input" = 10 ]] ;then
      echo "Updating payhere notify invoker lambda..."
      update_PaymentHandleInvoker_lambda
    elif [[ "$input" = 11 ]]; then
      echo "Updating user management lambdas..."
      update_auth_lambda

      echo "Updating bus management lambdas..."
      update_bus_lambda

      echo "Updating WSConnect lambdas..."
      update_WSConnect_lambda

      echo "Updating WSDisconnect lambdas..."
      update_WSDisconnect_lambda

      echo "Updating WSSendLocation lambdas..."
      update_WSSendLocation_lambda

      echo "Updating Notification invoker lambda..."
      update_notification_invoker_lambda

      echo "Updating general service lambda..."
      update_general_service_lambda

      echo "Updating booking service lambda..."
      update_booking_lambda

      echo "Updating seats-unlock invoker lambda..."
      update_SeatsUnlockInvoker_lambda

      echo "Updating payhere notify invoker lambda..."
      update_PaymentHandleInvoker_lambda
    fi
  fi
}
runner

