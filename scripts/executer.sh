#!/bin/bash

source './utils.sh'
source './user-management.sh'
source './stack-deployment.sh'
source './bus-management.sh'

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
    echo "3.All"

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
    elif [[ "$input" = 3 ]]; then
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
    fi

  fi
}

runner

