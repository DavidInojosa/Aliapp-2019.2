from flask import Flask
from flask_restful import Api, Resource, reqparse

# MISSING ACTIONS

# flask boilerplate
app = Flask(__name__)
api = Api(app)

entryList = [
        {
            "uid": 0,
            "nome": "Joaquim Ninim",
            "fone": "89 96434455",
            "email": "contato@lusofonos.pt",
            "last": 0
        },
        {
            "uid": 1,
            "nome": "Fulano de Tal",
            "fone": "81999692717",
            "email": "ehmolde@boy.rec",
            "last": 0
        },
        {
            "uid": 2,
            "nome": "João Grandão",
            "fone": "(81) 98676-1914",
            "email": "pede@feijao.ru",
            "last": 0
        },
        {
            "uid": 3,
            "nome": "Álvaro Campos",
            "fone": "996152730",
            "email": "dudu@vivo.com.br",
            "last": 0
        },
        {
            "uid": 4,
            "nome": "Continue Atestar",
            "fone": "+55 (104) 9 866 927 427",
            "email": "emailcumpridodagota@serena.com",
            "last": 0
        },
]

if __name__ == "__main__":
    import datetime as dt
    print(dt.datetime.now())

class Teste(Resource):
    def get(self):
        return "Tudo certo, nada errado"

# parser configutarion
clienteParser = reqparse.RequestParser()
clienteParser.add_argument('nome', required=True, help="falta um campo com o primeiro nome")
clienteParser.add_argument('fone')
clienteParser.add_argument('email')

# class definitions
class ListarClientes(Resource):
    def get(self):
        return entryList

    def post(self):
        args = clienteParser.parse_args()
        if not (args["email"] or args["fone"]):
            return {"message": "must provide email ou telefone"}
        uid = 1 + max(map( lambda x : x["uid"], entryList ))
        args["uid"] = uid
        args["last"] = 0
        entryList.append(args)
        return uid

class Buscar(Resource):
    def get(self, query):
        start = (lambda x : x["nome"].lower().startswith(query.lower()))
        return list(filter( start, entryList ))

class Clientes(Resource):
    def put(self, identifier):
        args = clienteParser.parse_args()
        if not (args["email"] or args["fone"]):
            return {"message": "must provide email ou telefone"}
        args["uid"] = identifier
        args["last"] = 0
        entryList[identifier] = args
        return identifier

    def get(self, identifier):
        return entryList[identifier] if identifier < len(entryList) else {"message": "no such cliente"}

# routes/resources
api.add_resource(Teste, '/')
api.add_resource(Clientes, '/cliente/<int:identifier>')
api.add_resource(Buscar, '/cliente/<string:query>')
api.add_resource(ListarClientes, '/cliente')

# if __name__ == "__main__":
#         app.run(host='0.0.0.0', debug=True)
