from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/ping')
def hello():
    return jsonify(message='py_ok')

if __name__ == "__main__":
    app.run(host='127.0.0.1', port=9092)
