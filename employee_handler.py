import json

def lambda_handler(event, context):
    print("Fetching employee directory...")
    
    employees = [
        {"id": 101, "name": "Sarah Connor", "role": "Cloud Engineer", "department": "DevOps"},
        {"id": 102, "name": "Alex Murphy", "role": "Data Analyst", "department": "Analytics"}
    ]
    
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps({"status": "success", "data": employees})
    }