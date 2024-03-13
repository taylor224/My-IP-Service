from flask import Flask, render_template, request
from werkzeug.middleware.proxy_fix import ProxyFix


app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.wsgi_app = ProxyFix(app.wsgi_app)

@app.route('/')
def index():
    client_ip = request.remote_addr
    return render_template('index.html', client_ip=client_ip)

