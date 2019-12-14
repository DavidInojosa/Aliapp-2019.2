#include <stdlib.h>
#include <stdio.h>
#include <wchar.h>

typedef struct entry_t {
    int uid;
    wchar_t nome[128];
    char fone[32], email[64];
    unsigned long last;
} entry;

#define DB_FILENAME "./usr/clientes.d"
typedef int offset_t;
const int OFFSET = sizeof(offset_t);

int generate(void)
{
    FILE *fh = fopen(DB_FILENAME, "wb");
    offset_t idx = 0;
    int ret = fwrite(&idx, sizeof(int), 1, fh);
    fclose(fh);
    return ret;
}

int getIndex(void)
{
    FILE *fh = fopen(DB_FILENAME, "rb");
    offset_t idx;
    fread(&idx, sizeof(offset_t), 1, fh);
    fclose(fh);
    return idx;
}

int append(entry *e)
{
    FILE *fh = fopen(DB_FILENAME, "r+b");
    offset_t idx;

    // read index
    fread(&idx, sizeof(offset_t), 1, fh);

    // go to next available pos and update index
    fseek(fh, OFFSET+(idx++*sizeof(entry)), SEEK_SET);

    // write entry
    fwrite(e, sizeof(entry), 1, fh);

    // return to beggining
    fseek(fh, 0, SEEK_SET);

    // write updated index
    fwrite(&idx, sizeof(offset_t), 1, fh);

    // close
    fclose(fh);

    // return updated index
    return idx-1;
}

int edit(int idx, entry *e)
{
    FILE *fh = fopen(DB_FILENAME, "r+b");
    fseek(fh, OFFSET+(idx*sizeof(entry)), SEEK_SET);
    fwrite(e, sizeof(entry), 1, fh);
    fclose(fh);
    return 1;
}

entry get(int idx)
{
    FILE *fh = fopen(DB_FILENAME, "rb");
    
    fseek(fh, OFFSET+(idx*sizeof(entry)), SEEK_SET);

    entry e;
    if (!fread(&e, sizeof(entry), 1, fh))
        e.uid = -1;

    fclose(fh);
    return e;
}