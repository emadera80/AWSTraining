#!/bin/bash
# ODH_D_TRVL_SRVC_STS_PROCESSOR

sor="Tcms"
sor_obj="Diagnostic"
target="ODH"
jobid="-1"
rs_key=""
idkey=""
FunctionName="${proj}_${lambenv}_${sor}${sor_obj}${target}"
FunctionArn="arn:aws:lambda:us-east-1:${accountid}:function:${FunctionName}"
envs="Variables={job_sor=$sor,job_sor_obj=$sor_obj,Environment=$tagenv,BACKLOG_THRESHOLD=5}"

#aws lambda --profile odhdev  get-function --function-name  $FunctionName
zip -r  -x$FunctionName.zip  $FunctionName  *

aws lambda delete-function  --function-name $FunctionName --profile $profile

aws lambda create-function \
--profile $profile \
--runtime python3.8 \
--role "arn:aws:iam::120373437580:role/$role" \
--vpc-config SubnetIds="subnet-ed23f1b5","subnet-dc11d8f6","subnet-2710d90d","subnet-a9f44fdf",SecurityGroupIds="sg-29cc0a53" \
--region "us-east-1" \
--tags "ApplicationGroup=$ApplicationGroup,Landscape=$Landscape,CostCenter=$CostCenter,WBSE=$WBSE,FundingSource=$FundingSource,ITDR=$ITDR" \
--function-name "$FunctionName" \
--handler "index.lambda_handler" \
--zip-file "fileb://$FunctionName.zip" \
--environment  $envs
