profile="training"
FunctionName="AWSTraining"
envs="Variables={test=test}"
land_bucket="em-employeedata"
region="us-east-1"
role="arn:aws:iam::037305576418:role/service-role/manny-function-role-hgxj91ih"
echo $FunctionName
zip -r  -x$FunctionName.zip  $FunctionName  *
aws lambda delete-function  --function-name $FunctionName --profile $profile
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
aws lambda add-permission --profile ${profile} \
--function-name $FunctionName \
--region $region \
--statement-id "some-unique-id" \
--action "lambda:InvokeFunction" \
--principal s3.amazonaws.com \
--source-arn arn:aws:s3:::em-employeedata \
--source-account 037305576418
echo "s3 add notification configuration"
aws s3api put-bucket-notification-configuration --profile $profile --bucket "$land_bucket" --region "${region}" --notification-configuration file://s3notification.json
echo "s3 notification added configuration"