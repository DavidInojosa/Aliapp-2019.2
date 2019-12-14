all: dblib actlib

dblib: src/fdb.c
	gcc -shared -Wall -O3 -o lib/dblib.so -fPIC src/fdb.c

actlib: src/adb.c
	gcc -shared -Wall -O3 -o lib/actlib.so -fPIC src/adb.c
