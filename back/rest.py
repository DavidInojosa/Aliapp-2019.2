from flask import Flask
from flask_restful import Api, Resource, reqparse
import filedb as fdb
import actiondb as adb

# flask boilerplate
app = Flask(__name__)
api = Api(app)

# aux functions
def updateList():
    global entryList
    entryList = fdb.getAll()
    for cli in entryList:
        cli_acts = adb.getByCli(cli["uid"])
        lasts   = list(filter(lambda x:  x["action"]!="futuro", cli_acts))
        futures = list(filter(lambda x:( x["action"]=="futuro" and x["stamp"]>=adb.getToday() ), cli_acts))
        cli ["last"] = lasts[0] if len(lasts) > 0 else {}
        cli ["future"] = futures[-1] if len(futures) > 0 else {}
    entryList.sort(key=(lambda x : x["nome"]))

# global var
updateList()

# server test frontpage
class Teste(Resource):
    def get(self):
        return "Tudo certo, nada errado"

# cliente parser configutarion
clienteParser = reqparse.RequestParser()
clienteParser.add_argument('nome', required=True, help="falta um campo com o primeiro nome")
clienteParser.add_argument('fone')
clienteParser.add_argument('email')

# action parser configutarion
actParser = reqparse.RequestParser()
actParser.add_argument('act', required=True)
actParser.add_argument('cliente', required=True)
actParser.add_argument('stamp')

# class definitions
class ListarClientes(Resource):
    def get(self):
        return entryList

    def post(self):
        args = clienteParser.parse_args()
        if not (args["email"] or args["fone"]):
            return {"message": "must provide email ou telefone"}
        uid = fdb.addEntry(**args)
        adb.addEntry("novo", uid)
        updateList()
        return uid

class Buscar(Resource):
    def get(self, query):
        start = (lambda x : query.lower() in x["nome"].lower())
        return list(filter( start, entryList ))

class Clientes(Resource):
    def put(self, identifier):
        args = clienteParser.parse_args()
        if not (args["email"] or args["fone"]):
            return {"message": "must provide email ou telefone"}
        uid = fdb.editEntry(uid=identifier, **args)
        updateList()
        return uid

    def get(self, identifier):
        cli      = fdb.getById(identifier)
        if cli == -1:
            print("WARN: Tentativa de acessar cliente inexistente", identifier)
            return {"message": "Cliente inexistente"}, 404
        cli_acts = adb.getByCli(cli["uid"])
        lasts   = list(filter(lambda x:  x["action"]!="futuro", cli_acts))
        futures = list(filter(lambda x:( x["action"]=="futuro" and x["stamp"]>=adb.getToday() ), cli_acts))
        cli ["last"] = lasts[0] if len(lasts) > 0 else {}
        cli ["future"] = futures[-1] if len(futures) > 0 else {}
        return cli
        

    def delete(self, identifier):
        ret = fdb.deleteEntry(identifier)
        updateList()
        return ret

class ListarAcoesId(Resource):
    def get(self, identifier):
        return adb.getByCli(identifier)

class ListarAcoesDia(Resource):
    def get(self, data):
        return adb.getByDay(data)

class Acoes(Resource):
    def get(self):
        return adb.getAll()

    def post(self):
        args = actParser.parse_args()
        ret = adb.addEntry(**args)
        if ret > -1:
            return {"message": "success", "uid": ret}
        else:
            return {"message": "failed"}

class ListarMapa(Resource):
    def get(self):
        return [ {"nome": "alicerce",
                         "lat": "0192931",
                         "lon": "0120391"}, 
                        {"nome": "cesar", 
                         "lat": "203123", 
                         "lon": "1293-0"} ]

# routes/resources
api.add_resource(Teste, '/')
api.add_resource(ListarClientes, '/cliente', '/cliente/')
api.add_resource(Clientes, '/cliente/<int:identifier>')
api.add_resource(Buscar, '/cliente/<string:query>')
api.add_resource(Acoes, '/act')
api.add_resource(ListarAcoesId, '/act/byId/<int:identifier>')
api.add_resource(ListarAcoesDia, '/act/byDay/<string:data>')
api.add_resource(ListarMapa, '/maps')

if __name__ == "__main__":
        app.run(host='0.0.0.0', debug=True)
