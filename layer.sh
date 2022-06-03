lname="manny-layer"
profile="training"
bucket="em-employeedata"
accountid="037305576418"
aws lambda add-layer-version-permission \
   --profile ${profile} \
   --layer-name "${lname}" \
   --statement-id "xaccount" \
   --action lambda:GetLayerVersion  \
   --principal ${accountid} \
   --version-number 1 \
   --output text
exit 0
aws lambda publish-layer-version \
    --profile ${profile} \
    --layer-name "${lname}" \
    --description "Python layer" \
    --license-info "MIT" \
    --content S3Bucket="${bucket}",S3Key="lambda/layers/python/python.zip " \
    --compatible-runtimes python3.6 python3.7 python3.8
exit 0
#attaching the python layer to function.
aws lambda update-function-configuration \
    --function-name AWSTraining \
    --layers "arn:aws:lambda:us-east-1:037305576418:layer:manny-layer:1" \
    --profile training

