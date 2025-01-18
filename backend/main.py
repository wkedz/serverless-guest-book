import logging
import os
import boto3

def get_items(table_resource: boto3.resource):
    response = table_resource.scan()
    return {"comments" : response["Items"]}

def put_item(table_resource: boto3.resource, post_data: str):
    response = table_resource.put_item(
        Item = post_data
    )
    return {"Status": response["ResponseMetadata"]["HTTPStatusCode"]}

def handler(event, context):
    logger = logging.getLogger()
    logger.setLevel("INFO")
    dynamodb_resource = boto3.resource("dynamodb")
    table_resource = dynamodb_resource.Table(os.getenv("TABLE_NAME"))

    logger.info("Received event:")
    logger.info(event)

    if event['requestContext']['http']['method'] == "GET":
        response = get_items(table_resource)
    if event['requestContext']['http']['method'] == "POST":
        response = put_item(table_resource, event["queryStringParameters"])
    
    logger.info("Returning response:")
    logger.info(response)
    return response
