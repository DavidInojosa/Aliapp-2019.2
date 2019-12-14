from ctypes import *
from datetime import *

lib = CDLL("./lib/actlib.so")

class Entry(Structure):
    _fields_ = [
            ("uid", c_int),
            ("cliente", c_int),
            ("action", c_char),
            ("stamp", c_ulong)
    ]

lib.generate.restype = c_int
lib.append.restype = c_int
lib.getIndex.restype = c_int
lib.get.restype = Entry

def addEntry(act, cliente, stamp=None):
    if stamp == None:
        stamp = datetime.now().timestamp()
    
    act_char = str()
    if act == "orcamento":
        act_char = b'O'
    elif act == "venda":
        act_char = b'V'
    elif act == "contato":
        act_char = b'C'
    elif act == "novo":
        act_char = b'N'
    elif act == "futuro" and stamp != None:
        act_char = b'F'
    else:
        return -1
    try:
        datetime.fromtimestamp(int(stamp))
    except OSError:
        return -1
    uid = lib.getIndex()
    e = Entry(
            uid,
            int(cliente),
            c_char(act_char),
            int(stamp),
            )
    return lib.append(pointer(e))

# def deleteEntry(uid):
#     e = Entry( -1, "", b"", b"", 0)
#     lib.edit(uid, pointer(e))
#     return uid
# 

def getById(uid):
    e = lib.get(c_int(uid))
    if e.uid >= 0:
        act_str = str()
        if e.action == b'O':
            act_str = "orcamento"
        elif e.action == b'V':
            act_str = "venda"
        elif e.action == b'C':
            act_str = "contato"
        elif e.action == b'N':
            act_str = "novo"
        elif e.action == b'F':
            act_str = "futuro"
        return {
                "uid": e.uid,
                "cliente": e.cliente,
                "action": act_str,
                "stamp": e.stamp
                }
    else:
        return -1

def mostRecent(ls):
    return sorted(ls, key=lambda x:x["stamp"], reverse=True)

def getAll():
    ls = list()
    for i in range(lib.getIndex()):
        c = getById(i)
        if "uid" in c.keys():
            ls.append(c)
    return mostRecent(ls)

def getByDay(day):
    mydate = date.fromisoformat(day)
    ls = getAll()
    return mostRecent(filter(lambda x : date.fromtimestamp(x["stamp"]) == mydate, ls))

def getByCli(clien):
    ls = getAll()
    return mostRecent(filter(lambda x : x["cliente"] == clien, ls))

def getToday():
    return datetime.today().timestamp()

if __name__ == "__main__":
    import pprint
    pretty_list = getAll()
    for entry in pretty_list:
        entry["stamp"] = datetime.fromtimestamp(entry["stamp"]).isoformat().replace("T", " ")
    pprint.pprint(pretty_list)
    # print(list(getByDay("2019-11-13") ))
    # print(list(getByCli(2)))
    # print(lib.generate())
    # today = datetime.now()
    # twoday = today + timedelta(days=3)
    # addEntry("orcamento", 2, (today+timedelta(days=-4)).timestamp())
    # addEntry("futuro", 2, (today+timedelta(days=-2, hours=-2)).timestamp())
    # addEntry("venda", 2, (today+timedelta(days=-2)).timestamp())
    # addEntry("futuro", 2, (twoday+timedelta(days=8)).timestamp())
    # addEntry("contato", 3, (today+timedelta(hours=-5)).timestamp())
    # addEntry("futuro", 3, (twoday+timedelta(hours=-3)).timestamp())
    # addEntry("orcamento", 1)
    # addEntry("futuro", 1, twoday.timestamp())
    # print(getAll())
