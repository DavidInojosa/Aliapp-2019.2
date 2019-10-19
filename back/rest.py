from flask import Flask
from flask_restful import Api, Resource, reqparse
from time import sleep

app = Flask(__name__)
api = Api(app)

class HelloWorld(Resource):
        def get(self):
                return "Hello World"

class Echo(Resource):
        def get(self, param):
                return "Oi, "+param

clientes_parser = reqparse.RequestParser()
clientes_parser.add_argument('name')

class ListarClientes(Resource):
        def get(self):
            keys = list(Clientes.clientes.keys())
            keys.sort()
            return [Clientes.clientes[idx]["nome"] for idx in keys]
        def post(self):
            args = clientes_parser.parse_args()
                
class Clientes(Resource):
    clientes = {
            1: {"nome": "Joaquim",
                "sobrenome": "Nabuco",
                "telefone": "96769833",
                "notas":"notas-joaquim.txt"},
            2: {"nome": "Romeu",
                "sobrenome": "Ijuliette",
                "telefone": "997478622",
                "notas":"notas-romeu.txt"},
            3: {"nome": "Fulano",
                "sobrenome": "De Tal",
                "telefone": "996748562",
                "notas":"notas-fulano.txt"},
            4: {"nome": "Sicrano",
                "sobrenome": "Alcoforado",
                "telefone": "996666969"}
            }
    def get(self, identifier):
        sleep(2.0)
        return self.clientes[identifier]

class Quiz(Resource):
        def get(self):
                return [
    {'q': 'quem eh o nosso cliente?',
           'alt': ["Clovis Henrique", "Alicerce", "Disensa", "CESAR"],
           'c': 1},
    {'q': 'o que o nosso cliente vende?',
           'alt': ["casacos de couro", "materiais de escritorio", "suor, lagrimas e sangue", "materiais de construcao"],
           'c': 3},
    {'q': 'quem e o rei do ovo',
           'alt': ["eu", "voce", "zooboo", "mafu"],
           'c': 0} ]

api.add_resource(HelloWorld, '/')
api.add_resource(Echo, '/<string:param>')
api.add_resource(Clientes, '/clientes/<int:identifier>')
api.add_resource(ListarClientes, '/clientes')
api.add_resource(Quiz, '/quiz') 

if __name__ == "__main__":
        app.run(host='0.0.0.0', debug=True)
