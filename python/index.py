
import json

def lambda_handler(event, context):
    try:
        # If the event is wrapped in a "body" field, parse it
        if 'body' in event:
            event = json.loads(event['body'])
        
        print(event)
        message = 'Hello {} !'.format(event.get('key1'))
        
        # Return the proper format
        return {
            'statusCode': 200,  # HTTP status code
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'message': message
            })  # Body needs to be a JSON string
        }
    
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'error': str(e)
            })
        }

""" def lambda_handler(event, context):
   message = 'Hello {} !'.format(event['key1'])
   return {
       'message' : message
   } """


# Example 1: Alternative Python pgm code for test, uncomment as needed
""" def lambda_handler(event, context):
   return {
       'statusCode': 200,
       'body': 'Hello, World!'
   } """

# Example 2: Alternative Python pgm code for test, uncomment as needed
""" 
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_user():
           return 'Hello, NTU User!'

@app.route('/ntu')
def hello_org():
       return 'Hello, NTU!'

###add more routes here if you want

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port= 80)
 """