typedef struct node node;
typedef struct list list;
#include <stdlib.h>
#include <stdbool.h>

struct node {
    char *data;
    struct node *next;
    struct node *prev;
};

struct list {
    int size;
    struct node *head;
    struct node *tail;
};

node* new_node(char *new_data)
{
    struct node* N = (struct node*) malloc(sizeof(node));
    N->data = new_data;
    N->next = NULL;
    N->prev = NULL;
}

list* new_list(struct node* N)
{
    struct list* lista = (struct list*) malloc(sizeof(list));
    lista->size = 0;
    lista->head = N;
    lista->tail = N;

    return lista;
}

bool isEmpty(struct list* L)
{
    return L->head == NULL;
}

void add(struct list* L, char *new_data )
{
    struct node* N = new_node(new_data);

    if(L->head == NULL)
    {
        L->head = N;
        L->tail = N;
    }
    else
    {
        N->prev = L->tail;
        L->tail->next = N;
        L->tail = N;
    }
    L->size++;
}



void insert_in(struct list* L, struct node* P, char *new_data)
{
    struct node* N = new_node(new_data);

    if(L->tail == P) {
        N->prev = L->tail;
        L->tail->next = N;
        L->tail = N;
    }
    else {
        N->prev = P;
        N->next = P->next;
        P->next = P;
    }
    L->size++;
}

node* get(struct list* L, int pos)
{
    struct node* temp;
    int dif = L->size - pos;

    if(pos <= dif){
        temp = L->head;
        for(int i=0; i < pos; i++)
        {
            temp = temp->next;
        }
        return temp;
    }
    //else
    temp = L->tail;
    for(int i=0; i < dif; i++)
    {
        temp = temp->prev;
    }
    return temp;
}

void insert_after(struct list* L, struct node* N, int pos, char *new_data)
{
    if(!isEmpty(L)){
        if (pos > 1)
        {
            insert_after(L,N->next, pos - 1, new_data);
        }else{
            struct node* new_N = new_node(new_data);
            new_N->prev = N;
            new_N->next = N->next;
            N->next->prev = new_N;
            N->next = new_N;
            L->size++;
        }
    }
    else {
        add(L, new_data);
    }
}

void delete_after(struct list* L, struct node* N, int pos)
{
    if(pos > 1)
    {
        delete_after(L,N->next, pos -1);
    }else{
        N->prev->next = N->next;
        N->next->prev = N->prev;
        free(N);
        L->size++;
    }
}

void insert_first(struct list* L, char *new_data)
{
    struct node* N = new_node(new_data);
    
    N->next = L->head;
    L->head->prev = N;
    L->head = N;
    L->size++;
}

void modify_after(struct node* N, int pos, char *new_data)
{
    if(pos > 1)
    {
        modify_after(N->next, pos - 1, new_data);
    }else{
        N->data = new_data;
    }
}

void delete_node(struct node* N)
{
    if(N->prev == NULL){
        N->next->prev = NULL;
        free(N);
    }else if(N->next == NULL){
        N->prev->next = NULL;
        free(N);
    }else{
        N->next->prev = N->prev;
        N->prev->next = N->next;
        free(N);
    }

}

void delete_node_inrange(struct node* N, int a, int b)
{
    struct node* temp1 = N;
    struct node* temp2 = N;
    for(int i=0; i < a; i++){
    }

}
