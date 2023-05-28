from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/grabar')
def grabar():
    print("Iniciando grabación")
    # Agrega aquí tu lógica para iniciar la grabación
    return ""

@app.route('/parar')
def grabar():
    print("parando grabación")
    return ""
    
            
if __name__ == '_main_':
    app.run(debug=True, host='0.0.0.0', port=5000)