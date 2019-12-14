from ctypes import *

lib = CDLL("./lib/dblib.so")

class Entry(Structure):
    _fields_ = [
            ("uid", c_int),
            ("nome", c_wchar*128),
            ("fone", c_char*32),
            ("email", c_char*64),
            ("last", c_ulong)
    ]

lib.generate.restype = c_int
lib.append.restype = c_int
lib.getIndex.restype = c_int
lib.get.restype = Entry


def addEntry(nome, fone="", email=""):
    if nome == None or nome == "":
        return -1
    else:
        uid = lib.getIndex()
        e = Entry( uid, nome,
                bytes(fone, encoding="ascii") if fone else b"",
                bytes(email, encoding="ascii") if email else b"",
                0 )
        lib.append(pointer(e))
        return uid

def editEntry(uid, nome, fone, email):
    if nome == None or nome == "":
        return -1
    else:
        e = Entry( uid, nome,
                bytes(fone, encoding="ascii") if fone else b"",
                bytes(email, encoding="ascii") if email else b"",
                0 )
        lib.edit(uid, pointer(e))
        return 1

def deleteEntry(uid):
    e = Entry( -1, "", b"", b"", 0)
    lib.edit(uid, pointer(e))
    return 1

def getById(uid):
    e = lib.get(c_int(uid))
    if e.uid >= 0:
        return {
                "uid": e.uid,
                "nome": e.nome,
                "fone": e.fone.decode("ascii"),
                "email": e.email.decode("ascii"),
                "last": e.last
                }
    else:
        return -1

def getAll():
    ls = list()
    for i in range(lib.getIndex()):
        c = getById(i)
        if c != -1:
            ls.append(c)
    return ls

if __name__ == "__main__":
    pass
    # print(c_int(lib.getIndex()))
    # print(lib.generate())
    # addEntry("Joaquim Ninim", "89 96434455", "contato@lusofonos.pt")
    # addEntry("Fulano de Tal", "81999692717", "ehmolde@boy.rec")
    # addEntry("João Grandão", "(81) 98676-1914", "pede@feijao.ru")
    # addEntry("Álvaro Campos", "996152730", "dudu@vivo.com.br")
    # addEntry("Continue Atestar", "+55 (104) 9 866 927 427", "emailcumpridodagota@serena.com")
    # print( [c["nome"] for c in getAll()] )
