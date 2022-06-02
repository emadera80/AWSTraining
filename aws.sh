profile="training"
FunctionName="manny-function"


zip -y function.zip index.py 


#aws lambda --profile $profile  get-function --function-name  $FunctionName

aws lambda delete-function  --function-name manny-function --profile training

aws lambda create-function --function-name manny-function --runtime python3.8 --role arnsomethinggoeshere --zip-file fileb://function.zip --handler index.handler --profile training
