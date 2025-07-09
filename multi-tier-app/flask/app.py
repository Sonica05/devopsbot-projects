from flask import Flask, jsonify
import redis
import os

app = Flask(__name__)
cache = redis.Redis(host=os.environ.get('REDIS_HOST', 'localhost'), port=6379)

@app.route('/')
def index():
    visits = cache.incr('counter')
    return jsonify(message="Hello from Flask!", visits=visits)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

