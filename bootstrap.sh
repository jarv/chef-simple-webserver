#!/bin/bash

set -e

stack_name=$1

aws cloudformation create-stack --region us-east-1 --stack-name $stack_name  --template-body file://cf/webserver.yaml

while true; do
    endpoint=$(aws cloudformation describe-stacks --region us-east-1  --stack-name $stack_name | jq '.Stacks[].Outputs[2].OutputValue')
    if [[ $endpoint != *null* ]]; then
        break;
    fi
    echo "Waiting for the CF stack to finish"
    sleep 5
done
echo "Stack Created, configuring $endpoint"
sleep 10
# Remove double quotes
endpoint="${endpoint%\"}"
endpoint="${endpoint#\"}"

knife solo prepare ubuntu@${endpoint}
knife solo cook ubuntu@${endpoint} -o webserver::default
