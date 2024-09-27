
def lambda_handler(event, context):
   message = 'Hello {} !'.format(event['key1'])
   return {
       'message' : message
   }

# Example 1: Alternative Python pgm code for test, uncomment as needed
""" def lambda_handler(event, context):
   return {
       'statusCode': 200,
       'body': 'Hello, World!'
   } """

# Example 1: Alternative Python pgm code for test, uncomment as needed
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