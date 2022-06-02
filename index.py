import pandas as pd 
import boto3 
import logging 
import logging.handlers
import os
import sys
import pg8000 as dbapi

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

region='us-east-1'
glue_client = boto3.client('glue', region_name=region)
lambda_client = boto3.client('lambda', region_name=region)  # , region_name=region)
s3_control = boto3.resource('s3', region_name=region)
s3_client = boto3.client('s3', region_name=region)
client_SecMgr = boto3.client("secretsmanager", region_name=region)
kms_client = boto3.client('kms', region_name=region)
sqs_client = boto3.client('sqs', region_name=region)
sns_client = boto3.client('sns', region_name=region)

def write_pd_parquet_s3(df):
    """This function convert the df to parquet and put the parquet to s3 location""" 
    response = s3_client.put_object(Bucket="em-employeedata", Key="output/employeedata.parquet", Body=df.to_parquet())

def lambda_handler(event, context):
    # TODO implement
    try: 
        getObj = s3_client.get_object(Bucket='em-employeedata', Key='EmployeeData.json')
        df = pd.read_json(getObj.get("Body"))
    except Exception as ex: 
        msg = "Failed to read data from S3 check s3 connection"
        logger.error(msg)

    try:
        write_pd_parquet_s3(df)
    except Exception as ex: 
        msg = 'Failed to write parquet file to s3 check connection'
        logger.error(msg)
    return




