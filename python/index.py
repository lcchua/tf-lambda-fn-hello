def lambda_handler(event, context):
   message = 'Hello {} !'.format(event['key1'])
   return {
       'message' : message
   }

# Alternative Python pgm code for test, uncomment as needed
""" def lambda_handler(event, context):
   return {
       'statusCode': 200,
       'body': 'Hello, World!'
   } """
