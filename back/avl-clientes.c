#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct cliente {
    char nome[32], sobre[32];
    unsigned long CPF, fone;
};

struct node {
    int id, height;
	struct node *left, *right, *up;
    struct cliente info;
};

int h(struct node *tree) { // height
	return tree ? tree->height : 0;
}

int bf (struct node *tree) { // balancing factor
	return h(tree->right) - h(tree->left);
}

void update_height(struct node *tree) {
	if (tree)
        tree->height = 1 + (h(tree->left) > h(tree->right) ? h(tree->left) : h(tree->right));
    return;
}

struct node *create(int val, struct cliente info)
{
	struct node *new = malloc(sizeof(struct node));
	new->id = val;
	new->left = NULL;
	new->right = NULL;
	new->height = 1;
    new->info = info;
	return new;
}

void rot(struct node **root, char dir)
{
	struct node *or = *root, *nr = dir=='r'? or->left : or->right;
	nr->up = or->up;
	or->up = nr;

	if (dir=='r') {
		or->left = nr->right;
		nr->right = or;
	} else {
		or->right = nr->left;
		nr->left = or;
	}
	update_height(or);
	update_height(nr);
	*root = nr;
    return;
}

void insert(int val, struct cliente info, struct node **tree)
{
	if (!*tree) {
		*tree = create(val, info);
		update_height(*tree);
	} else {
		insert(val, info, (val >
                 (*tree)->id ? &(*tree)->right : &(*tree)->left));
	}
	if (bf(*tree) < -1) {
		if (bf((*tree)->left) < 0) {
			rot(tree, 'r');
		} else {
			rot(&(*tree)->left, 'l');
			rot(tree, 'r');
		}
	} else if (bf(*tree) > 1) {
		if (bf((*tree)->right) > 0) {
			rot(tree, 'l');
		} else {
			rot(&(*tree)->right, 'r');
			rot(tree, 'l');
		}
	}
	update_height(*tree);
    return;
}

struct node *find(int val, struct node *tree)
{
    if (tree) {
        if (tree->id == val) return tree;
        else return find(val, tree->id > val? tree->left : tree->right);
    } else {
        return NULL;
    };
}

void print(struct node *node)
{
    if (node)
        printf("%i: \"%s %s\"\n", node->id, node->info.nome, node->info.sobre);
        printf("  fone: %lu\n  CNPJ: %lu\n", node->info.fone, node->info.CPF);
    return;
}

void inOrder(struct node *node) {
    if (node) {
        inOrder(node->left);
        print(node);
        inOrder(node->right);
    }
    return;
}
// WRAPPERS
/*
struct cliente {
    char nome[32], sobre[32];
    unsigned long CPF, fone;
};

void insert(int val, struct cliente info, struct node **tree); */

struct node *head;
int current_id;

int addCliente(char nome[], char sobre[], unsigned long fone, unsigned long CPF) {
    struct cliente novo;
    strcpy(novo.nome, nome);
    strcpy(novo.sobre, sobre);
    novo.fone = fone;
    novo.CPF = CPF;
    insert(current_id, novo, &head);
    return current_id++;
}

void printCliente(int id) {
    print(find(id, head));
    return;
}

void printAll() {
    inOrder(head);
}

void main (void) {
    addCliente("Joaquim", "Nabuco", 558121215999, 12887375000102);
    printAll();
    return;
}
