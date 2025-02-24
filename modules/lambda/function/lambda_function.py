
# This script is working and if any of the instance is stopped when you run workflow lambda will start the instance

import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='us-west-1')  # Change region if needed
    
    response = ec2.describe_instances(
        Filters=[
            {'Name': 'tag:StartWithLambda', 'Values': ['true']},
            {'Name': 'instance-state-name', 'Values': ['stopped']}  # Only stopped instances
        ]
    )
    
    instance_ids = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])
    
    if instance_ids:
        ec2.start_instances(InstanceIds=instance_ids)
        return {
            'statusCode': 200,
            'body': f'Started instances: {instance_ids}'
        }
    else:
        return {
            'statusCode': 200,
            'body': 'No instances to start'
        }




# import boto3
# import os

# def lambda_handler(event, context):
#     ec2_client = boto3.client("ec2")
    
#     # Read instance IDs from environment variable and convert them into a list
#     instance_ids = os.environ["INSTANCE_IDS"].split(",")

#     response = ec2_client.start_instances(InstanceIds=instance_ids)
    
#     return {
#         "statusCode": 200,
#         "body": f"EC2 instances {', '.join(instance_ids)} started successfully!"
#     }