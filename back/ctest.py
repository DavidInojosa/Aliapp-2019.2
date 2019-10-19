import os, sys, select
from ctypes import *

def more_data(): # check if more data to be read
        r, _, _ = select.select([pipe_out], [], [], 0)
        return bool(r)

def read_pipe():
        out = ''
        while more_data(): # read data to out
                out += str(os.read(pipe_out, 1024))

        return out

# load c program and start tree
l = CDLL('./libavl.so')
l.addCliente(b"Sicrano", b"Alcoforado", c_ulong(996666969), c_ulong(10230480000300))

# switch stdout and pipe
sys.stdout.write(' \b')
pipe_out, pipe_in = os.pipe() # create pipe
stdout = os.dup(1) # save stdout
os.dup2(pipe_in, 1) # replace stdout with pipe

# print to pipe
l.printAll()

# put stdout back in place
os.dup2(stdout, 1)
print('\nContents of stdout pipe:')
print(read_pipe())
