profile="training"
FunctionName="AWSTraining"
envs="Variables={test=test}"
land_bucket="em-employeedata"
region="us-east-1"
lname="manny-layer"
accountid="037305576418"
role="arn:aws:iam::037305576418:role/service-role/manny-function-role-hgxj91ih"
echo $FunctionName
#zip files 
zip -r  -x$FunctionName.zip  $FunctionName  *
#delete function 
aws lambda delete-function  --function-name $FunctionName --profile $profile
#create function
aws lambda create-function \
--profile $profile \
--runtime python3.8 \
--role "${role}" \
--vpc-config SubnetIds="subnet-0561b40f140e37bdd","subnet-0917df66d87eaaadb","subnet-0f22957e791ab5023","subnet-0bc02fafa4426fa15","subnet-06590950dea55e534",SecurityGroupIds="sg-00df8985052261e51" \
--region "us-east-1" \
--function-name "${FunctionName}" \
--handler "index.lambda_handler" \
--zip-file "fileb://$FunctionName.zip" \
--environment  $envs
exit 0
#add premission to the lambda
aws lambda add-permission --profile ${profile} \
--function-name $FunctionName \
--region $region \
--statement-id "some-unique-id" \
--action "lambda:InvokeFunction" \
--principal s3.amazonaws.com \
--source-arn arn:aws:s3:::em-employeedata \
--source-account 037305576418
#create notifications
echo "s3 add notification configuration"
aws s3api put-bucket-notification-configuration \
--profile $profile --bucket "$land_bucket" \
--region "${region}" \
--notification-configuration file://s3notification.json
echo "s3 notification added configuration"
#move the python layer to s3 
aws s3 cp python.zip s3://em-employeedata/lambda/layers/python/ --profile training
#create the layer
aws lambda publish-layer-version \
    --profile ${profile} \
    --layer-name "${lname}" \
    --description "Python layer" \
    --license-info "MIT" \
    --content S3Bucket="${bucket}",S3Key="lambda/layers/python/python.zip " \
    --compatible-runtimes python3.6 python3.7 python3.8
#create the layer permission
aws lambda add-layer-version-permission \
   --profile ${profile} \
   --layer-name "${lname}" \
   --statement-id "xaccount" \
   --action lambda:GetLayerVersion  \
   --principal ${accountid} \
   --version-number 1 \
   --output text
#attaching the python layer to function.
aws lambda update-function-configuration \
    --function-name AWSTraining \
    --layers "arn:aws:lambda:us-east-1:037305576418:layer:manny-layer:1" \
    --profile training