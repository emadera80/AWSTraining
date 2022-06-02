import pandas as pd 
import boto3 
import logging 
import logging.handlers
import os
import sys
import pg8000 as dbapi

df = pd.read_json("data/EmployeeData.json")
print(df.head())
