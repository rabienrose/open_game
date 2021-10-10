from flask import Flask
from flask import request


app = Flask(__name__)

if __name__ == '__main__':
    app.config['SECRET_KEY'] = 'xxx'
    app.config['UPLOAD_FOLDER'] = './raw'
    app.debug = True
    app.run('0.0.0.0', port=8000)
