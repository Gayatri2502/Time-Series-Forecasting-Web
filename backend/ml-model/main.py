from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app) 

@app.route('/')
def home():
    return 'Hello, World! This is the home page.'

@app.route('/about')
def about():
    return 'This is the about page.'

@app.route('/character', methods=['GET'])
def returnascii():
    d = {}
    inputQuery = str(request.args['query'])
    answer = str(ord(inputQuery))
    d["output"] = answer
    return d

@app.route('/dm')
def data_manipulation():
    d = {}
    a = int(request.args['a'])
    b = int(request.args['b'])

    addition = str(a + b)
    subtraction = str(a - b)
    
    d['addition'] = addition
    d['subtraction'] = subtraction

    return jsonify(d)

if __name__ == '__main__':
    app.run(debug=True)
